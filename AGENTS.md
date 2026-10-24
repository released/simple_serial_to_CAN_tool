# AGENTS.md
## Verified x64 EXE slimming 2026-10-25

- x64 only: exclude unused MFC dialog-control registration; preserve /O2,
  static CRT/MFC, security, Win32 definitions and required runtime files.
- Re-evaluate before adding CMFC/extended dialog controls. SELF_CHECK and
  docs/verification/exe-slimming-20261025.json record scoped evidence/limits.
- Destructors release resources without accessing already-destroyed HWNDs.

## Compiler-File Clean Safety

- Both canonical/legacy clean entries use standalone `scripts/clean_intermediates.ps1`.
- Preflight all paths/reparse points before deleting allowlisted files only; never recursively purge obj/tests/verify or infer unknown content is disposable.
- Preserve EXE/INI/DLL/data/log/evidence/unknowns at every nesting level. Codex runs actual clean plus nested-delivery/help/idempotence/junction tests automatically.

## simple_serial_to_CAN_tool Spec Baseline (2026-05-01)

本文件為目前專案主規格，整合「PC MFC Tool 需求」與「EVB 韌體 bridge 需求」。
如與舊討論衝突，以本文件為準。

---

## 1. Platform / Build Constraints

- Follow workspace `#READ_ME_FIRST#/PROJECT_LAYOUT.md` for PC-tool folder layout.
- Resource script: `src/SerialToCanIspToolMfc.rc`; icon: `src/res/app_icon.ico`;
  documentation screenshot: `docs/images/SerialToCanIspToolMfc.jpg`.
- Folder reorganization does not change protocol behavior or firmware/vendor trees.
- OS: Windows 10/11 x64（目標：任何 Windows 平台可執行）
- PC Tool: MFC native EXE（不依賴 Python runtime）
- Driver policy: 不需額外安裝 driver（優先使用 Windows 內建類別驅動）
- 傳輸介面（PC -> EVB）:
  - UART Serial
  - USB VCOM (CDC)
  - USB HID
- 專案目錄（PC side）:
  - `src/`
  - `scripts/`
  - `build/`
- MFC project baseline:
  - `SerialToCanIspToolMfc.sln`
  - `SerialToCanIspToolMfc.vcxproj`
  - output: `build/SerialToCanIspToolMfc.exe`
  - build script:
    - `scripts/build_mfc.ps1`
    - default behavior: auto-close running `SerialToCanIspToolMfc.exe` before build
    - optional bypass: `-CloseRunningTool $false`
  - clean script:
    - `scripts/clean_mfc.bat`
    - only removes generated build artifacts
    - must preserve:
      - `build/README.md`
      - `build/.gitkeep`
- Firmware folder 保持既有路徑與結構：
  - `firmware/M0A21BSP_serial_to_CAN/`

## 2. Product Goal
- 建立一個專屬 Nuvoton ISP serial-to-CAN 工具。
- PC MFC Tool 透過 UART 系列介面控制 EVB。
- EVB 將資料轉成 CAN（8 bytes frame）與 target bootloader 溝通。
- 完成 target MCU 的 Nuvoton ISP 更新。

## 3. Core UI/Flow Scope (PC Tool)
- Open COM
- Load Binary
- Set CAN Bitrate
- Enter Bootloader
- Erase
- Program
- Verify
- Run
- Progress Bar
- Log Window
- Scope lock:
  - 目前僅聚焦更新流程（`SetCanBitrate -> Enter -> Erase -> Program -> Verify -> Run`）
  - `CONFIG / Option Byte` 修改不屬於本階段目標

## 4. UART / Throughput Baseline
- UART baudrate options:
  - 115200
  - 460800
  - 921600
- Program 流程需支援 block-based pipeline，降低等待時間。

## 4.1 PC<->EVB Protocol Baseline (V1)
- framing:
  - SOF: `0x55 0xAA`
  - header: `Version, Type, Seq, Cmd, Status, PayloadLen`
  - CRC:
    - `HeaderCRC16` over header bytes (version..payload_len)
    - `PayloadCRC16` over payload
- CRC algorithm:
  - `CRC-16/CCITT-FALSE` (`poly=0x1021`, `init=0xFFFF`)
- command set:
  - `SetCanBitrate`, `EnterBootloader`, `Erase`, `ProgramBegin`, `ProgramBlock`, `ProgramEnd`, `Verify`, `Run`
- status code:
  - `Ok/Busy/BadCommand/BadArgument/CrcError/SequenceError/VerifyFailed/Timeout/InternalError`
- 詳細格式見：
  - `docs/PROTOCOL.md`
- disabled command policy (current phase):
  - EVB firmware 對 config 類命令回覆 `BadCommand`：
    - `IspReadConfig (0x34)`
    - `IspUpdateConfig (0x35)`
    - `IspCanReadConfig (0x40)`
- readback verify policy:
  - `CMD_VERIFY_READBACK_BLOCK (0x27)` 目前禁用（回 `BadCommand`）。
- erase policy for current target ISP_CAN profile:
  - 不可下 `A3000000 (ERASE_ALL)`。
  - `CMD_ERASE` 在 EVB 端為 no-op（僅回 `OK`），實際 page erase 由 target 在 word-write 過程自行處理。
- run policy for current target ISP_CAN profile:
  - `RUN_APROM (0xAB000000)` 採單次轉發鎖存；同一 session 重複收到 run 請求時，EVB 僅回 `OK`，不重複送 CAN `AB`。
  - 新 session 定義：`EnterBootloader` 成功或 `ProgramBegin`。
  - `RUN_APROM` 收尾順序固定為：先停止 EVB CAN、再回 UART `OK`、最後 `SYS_ResetChip()`；不可在 UART flush 期間保留 CAN 啟用狀態。
  - `RUN_APROM` 的 CAN stop 採 hard-stop（直接 reset CAN module），不可在此路徑使用 graceful `EnterInitMode + invalidate object` 關閉法。

## 5. Bridge Buffer Strategy (EVB Firmware)
- 多重 buffer 建議：
  - Buffer A: 正在接收 UART data
  - Buffer B: 正在透過 CAN 傳送
  - Buffer C: 等待 target ACK / retry
- Pipeline policy:
  - PC 端先送 2~4 個 block 給 bridge
  - Bridge 依序送 CAN
  - Target ACK 後釋放 block
  - PC 再補新 block
- current firmware implementation baseline:
  - `firmware/M0A21BSP_serial_to_CAN/SampleCode/Template/main.c`
  - includes:
    - UART frame parser + CRC verify
    - command handlers (`SetCanBitrate/Enter/Erase/ProgramBegin/ProgramBlock/ProgramEnd/Verify/Run`)
    - ProgramBlock queue depth `4` (delayed ACK after CAN programming done)
    - EVB->target CAN timing policy (dedicated single-target bus):
      - moderate timeout (`CMD=3000ms`, `ACK=800ms`)
      - internal CAN retry disabled (`retry=1`, single attempt)
      - current best-known baseline keeps page-boundary controls enabled:
        - pre-TX settle delay
        - post-ACK settle delay
        - page-boundary first-word duplicate guard
        - page-boundary TX cleanup slot
      - current diagnostic baseline for M0A21/M0A23 ISP_CAN target:
        - `BRIDGE_TARGET_PAGE_BOUNDARY_BYTES = 512`
        - `BRIDGE_TARGET_PAGE_BOUNDARY_DELAY_MS = 100`
        - `BRIDGE_TARGET_PAGE_ERASE_GUARD_BYTES = 4`
        - `ProgramBegin` optional payload extension carries tool-provided `page_boundary_ack_timeout_ms`
        - bridge applies that timeout only to the first 4-byte word at each `512-byte` boundary
      - the same baseline should be kept aligned across existing bridge EVB template projects
    - NuLink2-compatible warmup before first APROM write:
      - issue `A2000000` READ_CONFIG sequence (`14` frames) in `ProgramBegin`
      - target boot log can align better with reference `teraterm.log` pattern
    - optional per-word ACK readback trace:
      - `ProgramBegin` flag bit1 enables EVB to include per-word ACK readback data in successful `ProgramBlock` responses
      - PC tool uses this only for debug logging (`Log CAN TX/RX`)
    - optional page-first-word summary trace:
      - `ProgramBegin` flag bit2 enables EVB to include compact page-boundary summary data in `ProgramEnd`
      - records include page-first-word `addr / TX word / ACK word / tx_count / ack_count`
      - enabled only for debug logging (`Log CAN TX/RX`)
    - page-boundary guard / cleanup remains enabled because this is still the
      last known baseline with `Run OK` and `readback` reduced to 5 wrong words
    - failure diagnostics still include both `last_rx_cmd` and
      `last_tx_cmd/data` to distinguish stale RX from stale TX-object behavior
    - PCAN bus-trace finding:
      - EVB TX interrupt clear path must not use vendor helper
        `CAN_CLR_INT_PENDING_BIT()` on TX message objects.
      - Reason: that helper writes `CMASK.TXRQSTNEWDAT`, which can re-request
        the same TX object and replay the last `0x487` frame on bus many times.
      - TX-object interrupt clear must use an explicit "clear IntPnd only"
        path without `TXRQSTNEWDAT`.
      - EVB TX message objects must not enable `TXIE`.
      - TX completion is polled by `TXREQ`; enabling TX interrupts only adds
        unnecessary TX-object IRQ traffic and can interfere with RX ACK
        servicing.

## 6. Reference Code / Paths
- ISP reference code:
  - Nuvoton `NuvoISP` reference source
- Bridge reference code:
  - Nuvoton `NuLink2_ISP_Bridge` reference source

## 7. Milestones
- 第一優先：先完成 PC MFC Tool（可連線、載檔、燒錄流程、進度與 log）。
- 第二優先：依 EVB 型號完成 UART->CAN bridge firmware，對齊 ISP protocol 行為。

## 8. Rule for Future Changes
- 功能或流程變更時，必須同步更新：
  - `AGENTS.md`
  - `SELF_CHECK.md`
  - `HANDOFF.md`
- 禁止在 EVB firmware 啟用 CAN DAR register（`CAN_CON_DAR_Msk`）：
  - 不可新增或開啟 `CON.DAR=1` 相關設定作為重傳/時序對策。
  - 若後續確實需要評估 DAR，必須先在 `AGENTS.md` 與 `HANDOFF.md` 提出變更理由並取得使用者明確同意後才能導入。

## 9. Portability Rules (EVB Migration)

- ?? BSP ????????????? MCU ?????????
  - `bridge_board_config.h`
  - `bridge_board_config_<platform>.h`
  - `bridge_can_backend.h`
  - `bridge_can_backend_<platform>.h`
- ????? BSP ????????????? `bridge_board_config_*` ? `bridge_can_backend_*` ???
- ?????? golden sample?????????????????????????? BSP ??????
- `PC -> EVB` 與 `EVB -> Target` 上層流程模組不得直接綁定特定周邊名稱：
  - `bridge_host_link.c/.h`
  - `bridge_nuvoisp_can.c/.h`
  - 上述檔案不得直接使用 `UART0/UART1/CAN0/...` 等實例名稱
- MCU 周邊與 pin assignment 必須集中在硬體抽象層：
  - `bridge_board_config.h`：platform selector + 共用 policy
  - `bridge_board_config_<platform>.h`：該平台的 instance/peripheral/pin define 與 pinmux
  - `bridge_can_backend.h`：backend selector
  - `bridge_can_backend_<platform>.h`：該平台 CAN controller / mailbox / message-object / IRQ clear 細節
  - `bridge_hw_abstraction.c/.h`：只保留 board clock、UART、queue、system reset 與 backend glue
- 同一 MCU family 內變更 UART/CAN port 或 pin 時，原則上只改：
  - `bridge_board_config_<platform>.h`
- 跨 MCU family 或 CAN driver API 不相容時，原則上只改：
  - `bridge_board_config_<platform>.h`
  - `bridge_can_backend_<platform>.h`
- `bridge_hw_abstraction.c` 不應再直接承擔特定 CAN IP 的 message object / IFx / TXRQ / IRQ clear 細節。

## 10. Current Platform Split Baseline
- `bridge_board_config.h` 目前為 wrapper，透過 `BRIDGE_PLATFORM` 選擇：
  - `bridge_board_config_m0a23.h`
  - `bridge_board_config_m2a23.h`
  - `bridge_board_config_m253.h`
  - `bridge_board_config_m463.h`
  - `bridge_board_config_nuc131.h`
  - `bridge_board_config_nuc240.h`
- `bridge_can_backend.h` 目前為 wrapper，透過 `BRIDGE_PLATFORM` 選擇：
  - `bridge_can_backend_m0a23.h`
  - `bridge_can_backend_m2a23.h`
  - `bridge_can_backend_m253.h`
  - `bridge_can_backend_m463.h`
  - `bridge_can_backend_nuc131.h`
  - `bridge_can_backend_nuc240.h`
- 目前只有 `bridge_can_backend_m0a23.h` 已實作並驗證行為。
- 其他平台 header 已建立 skeleton，後續需依 BSP / driver API / CAN IP double confirm 後補齊。

## 11. Public README / Upload Hygiene
- `README.md` 作為 GitHub 首頁文件時，僅保留：
  - 專案用途
  - 支援平台 / EVB
  - build / quick start
  - repo 結構與文件入口
- 下列內容不得放在公開 `README.md`：
  - 本機絕對路徑
  - 暫時性 debug 結論
  - build artifact / log / trace / readback 實驗紀錄
  - 個人化 IDE / tool 設定
- 與功能開發、移植、除錯相關的細節應放在：
  - `AGENTS.md`
  - `HANDOFF.md`
  - `SELF_CHECK.md`
- 準備上 GitHub 前需排除：
  - `build/`
  - `.claude/`
  - `*.uvguix.*`
  - 本機暫存探測檔


