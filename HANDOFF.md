# HANDOFF.md
Last updated: 2026-05-01
Workspace: `simple_serial_to_CAN_tool`

---

## Current Authority
- Spec baseline: `AGENTS.md`
- QA checklist: `SELF_CHECK.md`
- Rule: 功能變更需同步更新 AGENTS / SELF_CHECK / HANDOFF
- Public README rule:
  - `README.md` 只保留 GitHub 導覽內容
  - 開發 / 除錯 / 移植細節留在 AGENTS / HANDOFF / SELF_CHECK

---

## Implemented In This Session
### 0) 2026-05-07 clean_mfc safety fix
- `scripts/clean_mfc.bat` previously deleted the whole `build/` directory and recreated it empty.
- Updated behavior:
  - keep `build/` in place
  - delete only explicitly allowlisted compiler/linker intermediates
  - preserve executables, INI files, required DLLs, data, logs, firmware images, and unknown delivery files
- Restored missing files:
  - `build/README.md`
  - `build/.gitkeep`

### 0) 2026-05-07 platform split baseline: board-config wrapper + CAN backend wrapper
- Goal:
  - make future EVB/MCU migration focus on two platform files instead of upper bridge flow files
- Implemented:
  - `bridge_board_config.h` is now a wrapper selected by `BRIDGE_PLATFORM`
  - added platform board-config headers:
    - `bridge_board_config_m0a23.h`
    - `bridge_board_config_m2a23.h`
    - `bridge_board_config_m253.h`
    - `bridge_board_config_m463.h`
    - `bridge_board_config_nuc131.h`
    - `bridge_board_config_nuc240.h`
  - `bridge_can_backend.h` is now a wrapper selected by `BRIDGE_PLATFORM`
  - added CAN backend headers:
    - `bridge_can_backend_m0a23.h` (implemented)
    - `bridge_can_backend_m2a23.h` (skeleton / `#error`)
    - `bridge_can_backend_m253.h` (skeleton / `#error`)
    - `bridge_can_backend_m463.h` (skeleton / `#error`)
    - `bridge_can_backend_nuc131.h` (skeleton / `#error`)
    - `bridge_can_backend_nuc240.h` (skeleton / `#error`)
  - `bridge_hw_abstraction.c` is now a thin wrapper:
    - board clock + UART
    - generic CAN RX queue
    - system reset
    - delegates CAN controller specifics to backend header
- Current default:
  - `BRIDGE_PLATFORM = BRIDGE_PLATFORM_M0A23`
- BSP double-confirmed pin references added into board-config headers:
  - `M2A23`: UART0 `PB12/PB13`, CANFD0 `PC4/PC5`
  - `M253`: UART4 `PA2/PA3`, CAN0 `PC4/PC5`
  - `M463`: UART0 `PB12/PB13`, CAN0 `PJ10/PJ11`
  - `NUC131`: UART0 `PB0/PB1`, CAN0 `PD6/PD7`
  - `NUC240`: UART0 `PB0/PB1`, CAN0 `PD6/PD7`, alternate CAN1 `PD14/PD15`
- Build:
  - `C:\\Keil_v5\\UV4\\UV4.exe -b ...\\Template.uvprojx -j0`
  - PASS
  - output observed:
    - `Template.axf` `2026-05-07 10:53:05`
    - `Template.bin` `2026-05-07 10:53:06`

### 0) 2026-05-07 PCAN trace root-cause finding: TX interrupt clear was replaying frames
- Evidence:
  - `build\\SerialToCanIspTool.trc` shows one logical `0x487` request being
    transmitted multiple times on bus before/after the first `0x784` ACK.
  - page-first-word examples (`0x00002000 / 0x00002800 / 0x00003000 / 0x00005000`)
    replay up to `82~86` times, while `teraterm_isp+nulink2pro.trc` is
    strictly one request / one ACK.
- Root cause:
  - EVB CAN IRQ handler used vendor helper `CAN_CLR_INT_PENDING_BIT()` on TX
    message objects.
  - That helper writes `CMASK.TXRQSTNEWDAT`, which re-requests transmission and
    causes bus-level replay of the last TX object.
- Fix:
  - `bridge_hw_abstraction.c`
  - add local helper `can_clear_int_pending_only(msg_obj)`
  - TX interrupt clear path and `bridge_hw_can_tx_cleanup_slot()` now clear only
    `IntPnd`, without `TXRQSTNEWDAT`
  - TX message objects are now loaded/triggered by local bridge code without
    `TXIE`; TX completion remains polling-based via `TXREQ`
- Rule:
  - Do not use `CAN_CLR_INT_PENDING_BIT()` for EVB TX message objects in this
    project.
  - Do not enable `TXIE` on EVB TX message objects in this project.

### 0) 2026-05-06 page-first-word minimal diagnostics
- Goal:
  - inspect whether EVB bridge internally re-touches page-first-word addresses without changing normal program flow
- Firmware:
  - `bridge_nuvoisp_can.c`
  - when `ProgramBegin` debug flag bit2 is enabled, `ProgramEnd` now returns compact page-boundary summary records
  - record fields:
    - `addr`
    - `tx_word`
    - `ack_word`
    - `tx_count`
    - `ack_count`
  - payload stays within current `HOST_MAX_PAYLOAD`
- Tool:
  - `src/core/isp_bridge_client.cpp`
  - when `Log CAN TX/RX` is enabled, tool logs:
    - `DBG PAGE0 ADDR=0x... TX=0x... ACK=0x... COUNT=tx/ack`

### 0) 2026-05-06 restore best-known page-boundary baseline
- Goal:
  - return EVB bridge to the last known good-ish state:
    - `Run OK`
    - no persistent `AB` flood
    - `readback.bin` reduced to 5 wrong page-first-word entries
- Restored:
  - page-boundary pre-TX settle delay
  - page-boundary post-ACK settle delay
  - page-boundary first-word duplicate guard
  - page-boundary TX cleanup slot path
- Kept:
  - `RUN_APROM` single-shot latch
  - `RUN_APROM` hard-stop shutdown order
  - per-word ACK trace
  - extended fail diagnostics with `last_tx_cmd/data`
- Current baseline constants:
  - `BRIDGE_TARGET_PAGE_BOUNDARY_BYTES = 2048`
  - `BRIDGE_TARGET_PAGE_BOUNDARY_DELAY_MS = 100`
- 2026-05-06 latest A/B:
  - reduce page-boundary delay from `500ms` to `100ms`
  - scope: delay value only; keep same pre-TX/post-ACK boundary structure
  - purpose: verify whether the remaining 5 page-first-word holes are sensitive to delay magnitude

### 0) 2026-05-06 extreme page-boundary delay A/B test
- Goal:
  - determine whether the remaining page-first-word loss is still purely host/EVB timing related
- Firmware:
  - `bridge_board_config.h`
  - set `BRIDGE_TARGET_PAGE_BOUNDARY_DELAY_MS = 500`
  - applies to both:
    - page-boundary pre-TX settle delay
    - page-boundary post-ACK settle delay
- Scope:
  - diagnostic only, not intended as final throughput setting
  - result: no improvement; rolled back in latest bridge baseline

### 1) 2026-05-06 page-boundary pre-TX settle delay
- Goal:
  - protect target page-boundary `erase -> first write` timing without modifying target MCU bootloader flow
- Firmware:
  - `bridge_nuvoisp_can.c`
  - page-boundary delay is now applied twice for target page first-word addresses:
    - before forwarding the boundary word
    - after that boundary word ACK succeeds
- Reason:
  - post-ACK delay protects `addr+4`
  - pre-TX delay protects the boundary word itself (`0x00000000`, `0x00002000`, ...)

### 2) 2026-05-06 build script auto-closes running tool
- Goal:
  - avoid `LNK1104` when `build\SerialToCanIspToolMfc.exe` is still open during rebuild
- Script:
  - `scripts/build_mfc.ps1`
  - default behavior now auto-closes running `SerialToCanIspToolMfc.exe` before MSBuild
  - optional bypass:
    - `-CloseRunningTool $false`
- Documentation synced:
  - `AGENTS.md`
  - `SELF_CHECK.md`
  - `HANDOFF.md`

### 1) 2026-05-06 page-boundary guard + TX cleanup
- Goal:
  - keep troubleshooting on EVB/tool side only, without modifying target MCU ISP_CAN boot flow
- Firmware:
  - `bridge_nuvoisp_can.c`
  - added session-local page-boundary first-word guard
    - each `addr % page_size == 0` may only be forwarded once per `ProgramBegin` session
    - duplicate boundary attempt now fails immediately with `STATUS_SEQUENCE_ERROR`
  - after successful ACK of a page-boundary word, EVB now explicitly cleans up the CAN TX message object before continuing
  - minimal fail payload extended to include:
    - `last_rx_cmd`
    - `last_tx_cmd`
    - `last_tx_data`
- Hardware abstraction:
  - `bridge_hw_abstraction.c/.h`
  - added `bridge_hw_can_tx_cleanup_slot()` for deterministic per-slot TX object cleanup after page-boundary ACK
- Tool source:
  - `src/core/isp_bridge_client.cpp`
  - parser updated to print new diagnostics when payload includes `last_tx_cmd/data`
- Build note:
  - EVB firmware rebuilt successfully
  - MFC rebuild may fail if `build\\SerialToCanIspToolMfc.exe` is still running/locked
  - latest observed lock holder:
    - `SerialToCanIspToolMfc.exe` PID `13844`

### 1) 2026-05-06 per-word ACK trace added
- Goal:
  - diagnose target flash corruption by comparing EVB expected word data against target ACK readback data
- Firmware:
  - `bridge_nuvoisp_can.c`
  - `ProgramBegin` payload flag bit1 now enables per-word ACK trace on successful `ProgramBlock`
  - successful `ProgramBlock` response payload format when enabled:
    - byte0 = word count in this block
    - bytes[1..] = sequential `ack_data` (`uint32_t LE`) for each programmed word
- Tool:
  - `src/core/isp_bridge_client.cpp`
  - when `Log CAN TX/RX` is enabled, tool requests ACK trace and logs:
    - `DBG RX ACKWORD ADDR=0x... EXP=0x... ACK=0x...`
- Scope:
  - no change to page-boundary policy
  - no change to retry/timeout policy
  - no change to target MCU flow

### 2) Project scaffold established
- Created folders:
  - `build/`
  - `scripts/`
  - `src/`
- Kept existing folder untouched:
  - `firmware/M0A21BSP_serial_to_CAN/`

### 3) Documentation baseline created
- Added files:
  - `AGENTS.md`
  - `README.md`
  - `HANDOFF.md`
  - `SELF_CHECK.md`
  - `build/README.md`

### 4) Scope captured
- PC MFC tool priority defined:
  - COM open
  - binary load
  - CAN bitrate
  - bootloader/erase/program/verify/run
  - progress/log
- EVB bridge direction defined:
  - UART/USB(VCOM/HID) -> CAN(8-byte)
  - block pipeline + bridge buffers (A/B/C)

### 5) MFC baseline implementation completed
- Added MFC solution/project:
  - `SerialToCanIspToolMfc.sln`
  - `SerialToCanIspToolMfc.vcxproj`
  - `SerialToCanIspToolMfc.vcxproj.filters`
- Added source files:
  - `src/app.h`, `src/app.cpp`, `src/main.cpp`
  - `src/main_frame.h`, `src/main_frame.cpp`
  - `src/resource.h`
- Added scripts:
  - `scripts/build_mfc.ps1`
  - `scripts/build_release_mfc.bat`
  - `scripts/clean_mfc.bat`
- Implemented UI scaffold:
  - COM scan / open / close
  - baudrate selection (`115200/460800/921600`)
  - binary load (`.bin/.hex`) + file size display
  - CAN bitrate dropdown + set action
  - flow buttons: Enter Bootloader / Erase / Program / Verify / Run
  - progress bar + log window + clear log
- Implemented first program flow stub:
  - block size `256` bytes
  - progress updates by block count
  - log shows block progress
- Build verification:
  - `scripts\\build_mfc.ps1 -Configuration Release -Platform x64`
  - PASS
  - output: `build\\SerialToCanIspToolMfc.exe`

### 5) Protocol + real UART command path implementation completed
- Added protocol/core modules:
  - `src/core/bridge_protocol.h/.cpp`
  - `src/core/serial_port.h/.cpp`
  - `src/core/isp_bridge_client.h/.cpp`
- Added protocol document:
  - `docs/PROTOCOL.md`
- Implemented PC<->EVB framing:
  - `SOF(0x55,0xAA) + Ver + Type + Seq + Cmd + Status + Len + HeaderCRC16 + Payload + PayloadCRC16`
  - CRC: `CRC-16/CCITT-FALSE`
- Implemented real UART command actions:
  - `Set CAN Bitrate`
  - `Enter Bootloader`
  - `Erase`
  - `ProgramBegin/ProgramBlock/ProgramEnd`
  - `Verify`
  - `Run`
- Implemented Program pipeline state machine:
  - prefetch window `2~4` (UI selectable)
  - per-block ACK by `Seq`
  - ACK timeout detection
  - per-block retry (`max_retries`)
- UI updates:
  - added `Prefetch` combo (`2/3/4`)
  - program progress now driven by ACKed blocks
- Project updates:
  - `SerialToCanIspToolMfc.vcxproj` + filters include new `src/core/*`
- Build verification:
  - `scripts\\build_mfc.ps1 -Configuration Release -Platform x64`
  - PASS

### 6) EVB firmware parser/cmd handler implementation completed
- Updated firmware entry:
  - `firmware\\M0A21BSP_serial_to_CAN\\SampleCode\\Template\\main.c`
- Implemented UART protocol parser (same `docs/PROTOCOL.md`):
  - SOF `55 AA`
  - header fields: version/type/seq/cmd/status/len
  - `HeaderCRC16` + `PayloadCRC16` (`CRC-16/CCITT-FALSE`)
- Implemented EVB command handlers:
  - `SetCanBitrate`
  - `EnterBootloader`
  - `Erase`
  - `ProgramBegin`
  - `ProgramBlock`
  - `ProgramEnd`
  - `Verify`
  - `Run`
- Implemented ProgramBlock queue/pipeline on EVB:
  - queue depth `4`
  - `ProgramBlock` ACK is delayed until CAN word-programming completes
  - CAN ACK timeout/retry per 32-bit word
- Implemented CAN bridge mapping baseline:
  - send `cmd32 + data32` via CAN 8-byte frame
  - IDs: bridge->target `0x487`, target->bridge `0x784`
  - control commands:
    - connect `0xAE000000`
    - erase all `0xA3000000`
    - run aprom `0xAB000000`
  - program word:
    - `cmd32 = target_addr`
    - `data32 = word`

### 7) Firmware cleanup for bridge-only behavior
- File:
  - `firmware\\M0A21BSP_serial_to_CAN\\SampleCode\\Template\\main.c`
- Cleanup:
  - removed `stdio` dependency and any `printf` path in bridge main flow
  - removed unused helper macro
  - kept existing UART/CAN pin assignment unchanged:
    - UART0: `PB4 TXD`, `PB6 RXD`
    - CAN0: `PB7 TXD`, `PB5 RXD`

### 8) Firmware modular split + low-SRAM tuning
- Refactored EVB firmware from single-file into reusable modules:
  - `bridge_host_link.c/.h`: PC side framing parser + UART ISR + response framing
  - `bridge_nuvoisp_can.c/.h`: target side Nuvoton ISP-over-CAN command handler + queue state machine + CAN ISR
  - `main.c`: only clock/pin/UART init + SysTick + module glue
- Keil project updated:
  - `Template.uvprojx` now includes:
    - `bridge_host_link.c`
    - `bridge_nuvoisp_can.c`
- SRAM-aware bridge buffer/queue profile (for M0A23 4KB SRAM):
  - Host payload cap: `96` bytes
  - Program queue depth: `4`
  - Program block cap: `80` bytes
  - Recommended PC block size: `64`
- ProgramBlock retry robustness improved:
  - queue-based delayed ACK
  - duplicate resend handling for in-queue / already-ACKed blocks (ACK history depth 4)

### 9) ISP host command-format import (NuvoISP + NuLink2 reference)
- Added protocol command IDs `0x30..0x42` for ISP host style commands.
- EVB firmware now supports forwarding these command formats as CAN `cmd32+data32` requests with timeout/retry:
  - get version / connect / sync packno / get device id
  - read config / update config
  - update APROM word / update DataFlash word
  - erase all / run APROM / run LDROM / reset / resend packet
  - erase SPI flash / update SPI flash word
  - CAN-specific get device id / read config / run APROM
  - generic raw command: `IspRaw32` (custom cmd32/data32 + optional timeout/retry/flags)
- This import is command-format focused and does not gate on target capability.

### 10) Resend/verify hardening imported from ISPTool_Cross_Platform pattern
- `bridge_host_link` resend-safe behavior added:
  - request key = `seq + cmd + payload_len + payload_crc`
  - if host retransmits the same request and EVB has cached response, EVB directly replays cached response without re-executing command
  - reduces duplicate erase/program side effects when UART response is lost
- `ProgramBegin` flags (`payload[11]`) defined:
  - bit0: disable `CAN_CMD_SECOND_READ` verify
  - bit1: strict `CAN_CMD_SECOND_READ` verify (no fallback)
  - default `0`: auto mode (try second-read once, fallback if target does not support)
- Program word write path hardened:
  - after each CAN word write ACK, optional `CAN_CMD_SECOND_READ (0xB3000000)` readback compare against written word
  - mismatch returns `STATUS_VERIFY_FAILED`
  - strict mode keeps this mandatory; auto mode falls back on unsupported target
- Updated docs:
  - `docs/PROTOCOL.md` updated for ProgramBegin flags and duplicate-request replay behavior

### 11) Scope lock: disable CONFIG/Option-byte path on EVB bridge
- Goal alignment:
  - EVB is used as update bridge only (`SetCanBitrate -> Enter -> Erase -> Program -> Verify -> Run`)
  - `CONFIG / Option Byte` modification is out-of-scope in this phase
- Firmware behavior update:
  - disabled wrapper commands (reply `STATUS_BAD_COMMAND`):
    - `CMD_ISP_READ_CONFIG (0x34)`
    - `CMD_ISP_UPDATE_CONFIG (0x35)`
    - `CMD_ISP_CAN_READ_CONFIG (0x40)`
  - `CMD_ISP_RAW32 (0x42)` now blocks config opcodes:
    - `0xA1000000`, `0xA2000000`, `0xE0000000`, `0xE1000000`
- Updated docs:
  - `docs/PROTOCOL.md`
  - `README.md`
  - `SELF_CHECK.md`

### 12) Hardware abstraction for fast EVB migration
- Added:
  - `firmware\\M0A21BSP_serial_to_CAN\\SampleCode\\Template\\bridge_board_config.h`
  - `firmware\\M0A21BSP_serial_to_CAN\\SampleCode\\Template\\bridge_hw_abstraction.h`
  - `firmware\\M0A21BSP_serial_to_CAN\\SampleCode\\Template\\bridge_hw_abstraction.c`
- Refactor:
  - `bridge_host_link.c` no longer contains UART instance-specific operations/ISR.
  - `bridge_nuvoisp_can.c` no longer contains CAN instance-specific operations/ISR.
  - `main.c` now calls abstracted board/uart init only.
- New rule:
  - `PC->EVB` and `EVB->target` protocol flow modules must not directly bind to `UARTx/CANx`.
  - Peripheral and pin binding must stay in abstraction/config layer.
- Pin assignment:
  - kept current default pin assignment unchanged (UART0/CAN0 mapping on current EVB)
  - added UART0/CAN0 TXD/RXD define reference list in `bridge_board_config.h` for quick switch
- Follow-up refine:
  - moved UART/CAN instance-to-peripheral macro mapping into `bridge_board_config.h`
  - `bridge_hw_abstraction.c` now consumes pre-resolved macros only (no local instance switch `#if`)
  - target in same MCU family: single-file switch by editing `bridge_board_config.h`
- Keil project update:
  - `Template.uvprojx` includes `bridge_hw_abstraction.c`

### 13) UI icon branding update (C mark, light orange background)
- Goal:
  - unify app icon across title bar, taskbar, and File Explorer
- Added files:
  - `res\\app_icon.ico` (white `C` on light orange background)
  - `SerialToCanIspToolMfc.rc`
- Project wiring:
  - `SerialToCanIspToolMfc.vcxproj` adds resource compile/image entries
  - `SerialToCanIspToolMfc.vcxproj.filters` adds `Resource Files` grouping
  - `src\\resource.h` adds `IDI_APP_ICON`
  - `src\\main_frame.cpp` sets class/window icon via `AfxGetApp()->LoadIcon(IDI_APP_ICON)` and `SetIcon(...)`
- Build verification:
  - `scripts\\build_mfc.ps1 -Configuration Release -Platform x64`
  - PASS

### 14) Readback verify policy correction (follow host references)
- User-confirmed policy:
  - `CMD_VERIFY_READBACK_BLOCK (0x27)` must use `B300 SECOND_READ` only.
  - Do not fallback to `A200 READ_CONFIG` in readback verify path.
- Firmware change:
  - `firmware\\M0A21BSP_serial_to_CAN\\SampleCode\\Template\\bridge_nuvoisp_can.c`
  - removed `A200` fallback from `handle_verify_readback_block`.
- Docs synced:
  - `AGENTS.md`
  - `docs/PROTOCOL.md`
  - `SELF_CHECK.md`

### 15) Disable A300 erase-all for ISP_CAN target profile
- User-confirmed target behavior:
  - target/host reference flows use `B1000000`, `A2000000`, `AB000000`.
  - `A3000000 (ERASE_ALL)` is not allowed for this profile.
- Firmware change (`bridge_nuvoisp_can.c`):
  - `CMD_ERASE (0x21)` changed to no-op `STATUS_OK` (no CAN `A3` transmission).
  - `CMD_ISP_ERASE_ALL (0x38)` now returns `STATUS_BAD_COMMAND`.
  - `CMD_ISP_RAW32 (0x42)` now blocks `0xA3000000`.
- Docs synced:
  - `AGENTS.md`
  - `docs/PROTOCOL.md`
  - `SELF_CHECK.md`
  - `HANDOFF.md`

### 16) RUN_APROM anti-repeat guard
- Symptom:
  - observed repeated `AB000000` on target boot log after program flow/disconnect.
- Firmware change (`bridge_nuvoisp_can.c`):
  - add `RUN_APROM` single-shot latch (`s_run_aprom_sent`).
  - `CMD_RUN`, `CMD_ISP_RUN_APROM`, `CMD_ISP_CAN_RUN_APROM`, and `IspRaw32(cmd32=AB000000)` share same single-shot forward path.

### 17) RUN_APROM shutdown order
- 2026-05-06:
  - `send_ok_then_reset()` 改為先 `bridge_hw_can_stop()`，再回 host `OK`，最後 `SYS_ResetChip()`
  - 目的：避免 target 收到第一筆 `AB000000` 後，EVB 在 UART flush 視窗內仍保持 CAN 啟用，造成重複 `AB`
  - 這是 bridge 端收尾順序修正，不涉及 target MCU protocol 變更
  - 後續追加：`bridge_hw_can_stop()` 改為 hard-stop，直接 reset CAN module；原因是 graceful stop 可能卡在 live TX object，導致 host 收不到 `Run OK`、EVB 也無法 reset

### 18) Post-page-boundary settle delay
- 2026-05-06:
  - `ProgramBlock` 內原本已存在 page-boundary ACK 後延遲；此次將設定改為更貼近 M0A23 target:
    - boundary bytes: `2048`
    - delay: `100ms`
  - 背景：關閉 target `BOOT_DEBUG_PRINT_CMD` 後，`addr=0x00000000` 成功但 `0x00000004` 立即 timeout，表示 target 在 page 首字寫入完成後仍需要額外 settle 時間
  - latch reset on successful `EnterBootloader` and `ProgramBegin`.
- Effect:
  - same session repeated run requests no longer repeatedly send CAN `AB000000`.

### 17) CAN auto-retransmit disabled + word-level timeout tuning exposed
- Symptom:
  - target boot log still observed duplicate write addresses and persistent `AB000000` flood until EVB reset.
- Current status:
  - `DAR`-related changes were rolled back per latest decision.
  - Current firmware no longer modifies CAN auto-retransmit.

### 18) Program word duplicate-address guard
- Goal:
  - prevent repeated writes to same flash address when ACK is delayed/lost.
- Firmware change:
  - `firmware\\M0A21BSP_serial_to_CAN\\SampleCode\\Template\\bridge_nuvoisp_can.c`
  - add guarded write behavior in `service_program_queue`:
    - pre-read (`B300`) before write; skip write if data already matches
    - if write ACK timeout, do `B300` readback check first; if match, accept as success (ACK loss)
    - only resend write when readback proves value not written yet
- Tradeoff:
  - extra `B300` traffic increases programming time, but avoids duplicate address programming risk.

### 19) EVB CAN timeout x5 + internal retry disabled
- User requirement:
  - dedicated EVB<->target CAN bus, no other devices
  - avoid repeated write-address side effects from retry loop
- Firmware change:
  - `firmware\\M0A21BSP_serial_to_CAN\\SampleCode\\Template\\bridge_nuvoisp_can.c`
  - set:
    - `CAN_CMD_TIMEOUT_MS = 10000` (was 2000)
    - `CAN_ERASE_TIMEOUT_MS = 25000` (was 5000)
    - `CAN_ACK_TIMEOUT_MS = 2500` (was 500)
    - `CAN_MAX_RETRY = 1` (single attempt, no internal resend)
- Effect:
  - timeout-triggered false retry is reduced
  - EVB no longer internally re-sends same write address command.

### 20) Remove B300 SECOND_READ path (NuLink2-compatible)
- User requirement:
  - NuLink2-Pro flow does not issue `B300`; bridge should not issue `B300`.
- Firmware change:
  - `firmware\\M0A21BSP_serial_to_CAN\\SampleCode\\Template\\bridge_nuvoisp_can.c`
  - remove all `CAN_CMD_SECOND_READ (0xB3000000)` usage in program/write path.
  - `CMD_VERIFY_READBACK_BLOCK (0x27)` changed to `STATUS_BAD_COMMAND`.
  - `ProgramBegin` flags are now reserved/ignored in current profile.
- Verify strategy replacement:
  - rely on write ACK + final bridge CRC verify (`CMD_VERIFY`) in normal flow.
- Note:
  - this supersedes older notes that required/used B300 second-read verify.

### 21) Align target log pattern with `teraterm.log` (A200 warmup)
- Reference:
  - `build\\teraterm.log` shows sequence close to:
    - `B1`, `B1`, repeated `A200`, then APROM word-address stream, finally `AB`.
- Firmware change:
  - `firmware\\M0A21BSP_serial_to_CAN\\SampleCode\\Template\\bridge_nuvoisp_can.c`
  - in `handle_program_begin`, add `READ_CONFIG (A2000000)` warmup sequence:
    - count = `14` frames (`PROGRAM_BEGIN_READCFG_WARMUP_COUNT`)
    - data field uses `0,4,8,...`
- Goal:
  - make target boot log pattern under tool+EVB closer to NuLink2-Pro reference trace.

### 22) Diagnose slow + duplicate address writes (`serial_to_can_isp_20260502_002324.log`)
- Observed symptom:
  - programming speed too slow
  - target log still shows duplicated word address (e.g. `0x00000300`, `0x0000033C`)
- Root cause summary:
  - previous timeout profile (`CMD=10000`, `ACK=2500`) made each missed ACK stall too long
  - CAN HW auto retransmit can repeat same frame on bus error, causing duplicate address on target side
- Firmware adjustment:
  - `bridge_nuvoisp_can.c` constants tuned to:
    - `CAN_CMD_TIMEOUT_MS = 3000`
    - `CAN_ERASE_TIMEOUT_MS = 10000`
    - `CAN_ACK_TIMEOUT_MS = 800`
    - `CAN_MAX_RETRY = 1`
- Expected effect:
  - reduce long wait stalls
  - keep EVB software path single-attempt (no internal resend loop)
- PC-side default tuning:
  - `src/core/isp_bridge_client.h`
  - `ack_timeout_ms`: `3000 -> 1200`
  - `max_retries`: `5 -> 2`

---

## Next Suggested Work
1. 上線測試：以實機完整驗證 `SetCanBitrate -> Enter -> Erase -> Program -> Verify -> Run`。
2. 測試重送/容錯：驗證 block retry、duplicate request replay、second-read verify（auto/strict/disable）。
3. 測試可移植切換：僅改 `bridge_board_config.h` 驗證不同 UART/CAN port/pin 可正常運作（同 MCU family）。
4. 若發現 target bootloader ACK/timeout 差異，再回調 `bridge_nuvoisp_can.c` command timeout/mapping。

### Optional Backlog (not blocker for go-live test)
1. `Load Binary` 的 `.hex` 解析補齊（目前為 raw binary 讀取）。
2. `Cancel Program` 與執行中按鈕鎖定策略。

---

## Notes
- 目前已完成可編譯可執行的 MFC 第一版骨架。
- 已完成 PC 端 ISP/UART framing 與 Program pipeline 狀態機。
- EVB firmware 已對齊 `docs/PROTOCOL.md` parser/cmd handler。
- 本回合未在本機執行 Keil/ARM 編譯，需於 Keil 專案做一次完整編譯與燒錄驗證。




- ?? BSP ????????????? MCU ?????????
  - `bridge_board_config.h`
  - `bridge_board_config_<platform>.h`
  - `bridge_can_backend.h`
  - `bridge_can_backend_<platform>.h`
- ????? BSP ????????????? `bridge_board_config_*` ? `bridge_can_backend_*` ???
- ?????? golden sample?????????????????????????? BSP ??????
### 0) 2026-05-13 M0A21/M0A23 target page-boundary basis fix
- Scope:
  - `M2A23` bridge used with `M0A21/M0A23 ISP_CAN` target profile
- Root cause:
  - bridge page-boundary delay / erase-ACK diagnostic basis was left at `2048`
  - target bootloader actually erases on `512-byte` flash page boundaries
  - first failing block was `addr=0x00000200`, exactly target page boundary, so bridge did not apply boundary settle/extended timeout at the right place
- Change:
  - `BRIDGE_TARGET_PAGE_BOUNDARY_BYTES = 512`
  - `BRIDGE_TARGET_PAGE_SIZE_DIAG_BYTES = 512`
- Expected effect:
  - bridge page-boundary pre/post settle and erase-ACK extended timeout now align with target flash erase boundary

### 0) 2026-05-13 M0A23 bridge first-word timeout override
- Scope:
  - `M0A21BSP_serial_to_CAN` bridge project used as `M0A23` EVB bridge baseline
  - PC MFC tool `ProgramBegin` path
- Change:
  - bridge page-boundary basis fixed at `512 bytes`
  - first-word erase guard reduced to `4 bytes`
  - `ProgramBegin` now accepts an optional `page_boundary_ack_timeout_ms` trailing field
  - tool now always sends that field and logs the configured value at program start
- Intent:
  - timeout policy is chosen by the tool
  - bridge remains the runtime executor of the tool-provided worst-case timeout
  - only the first 4-byte word at each `512-byte` boundary receives the extended timeout

### 0) 2026-05-13 bridge baseline rollout
- Scope:
  - `M2A23 / M253 / M463 / M467 / NUC131 / NUC240` bridge template projects
- Change:
  - align board config boundary basis to `512 bytes`
  - align first-word erase guard to `4 bytes`
  - add `ProgramBegin` optional `page_boundary_ack_timeout_ms` support in each bridge `bridge_nuvoisp_can.c`
- Verification status:
  - `M2A23` build log generated successfully
  - `M253 / M463 / M467` source updated, but no fresh `*.build_log.htm` was produced in this environment
  - `NUC131 / NUC240` source updated; no Keil project file was present under their template folders in this workspace

### 0) 2026-05-13 target erase workaround rollback
- Scope:
  - `demo_code/M0A21BSP_ISP_CAN_APROM_demo`
- Change:
  - remove the temporary `2KB` multi-page pre-erase workaround
  - restore page erase trigger to `FMC_FLASH_PAGE_SIZE` boundary so target write path is closer to original BSP ISP_CAN behavior
