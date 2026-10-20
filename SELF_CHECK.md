Post-Generation Self-Review Checklist (simple_serial_to_CAN_tool)

請對每一項填寫 PASS / FAIL，若 FAIL 需附原因與修正檔案。

## Layout Migration 2026-10-20

- Moved root resource script/icon/screenshot to `src/SerialToCanIspToolMfc.rc`, `src/res/app_icon.ico`, and `docs/images/SerialToCanIspToolMfc.jpg`; initial moves were no-overwrite and SHA-256 verified.
- Updated project/filter/resource paths and relative README link. Application/protocol/firmware/vendor code is unchanged.
- PASS: Release x64 via `scripts/build_mfc.ps1 -CloseRunningTool $false`, 0 warnings/errors, normal generated version `0.1.0.0031` (completed before the repository-repair interruption; not needlessly bumped again).
- PASS on resume: shared isolated captioned-frame startup/normal-close, exit 0; no connection or hardware writes.
- PASS on resume: actual `scripts/clean_mfc.bat`; 1 protected build file unchanged (SHA-256). Fixture retained 9 delivery/runtime sentinels plus source; repeat clean passed.
- Publication uses the user's existing-delivery policy: update the already tracked EXE only; never newly add private INIs/logs/firmware artifacts. This takes precedence over the older blanket `build/` upload note.
- NOT RUN: physical bridge/MCU, firmware builds/programming, full UI/DPI and Debug acceptance.
- Commit/push evidence: workspace `#READ_ME_FIRST#/PROJECT_LAYOUT_MIGRATION.md`.

==================================================
Section 1 — Scaffold / Build Baseline
==================================================

[BASE-01] Folder scaffold
- Verify folders exist:
  - `build/`
  - `scripts/`
  - `src/`

Result: PASS / FAIL

[BASE-02] Firmware folder integrity
- Verify `firmware/M0A21BSP_serial_to_CAN/` remains intact.

Result: PASS / FAIL

[BASE-03] Documentation baseline
- Verify files exist and readable:
  - `AGENTS.md`
  - `README.md`
  - `HANDOFF.md`
  - `SELF_CHECK.md`
- Verify public `README.md` does not contain local absolute paths.

Result: PASS / FAIL

[BASE-04] MFC project files
- Verify these files exist:
  - `SerialToCanIspToolMfc.sln`
  - `SerialToCanIspToolMfc.vcxproj`
  - `SerialToCanIspToolMfc.vcxproj.filters`
- Verify build scripts exist:
  - `scripts/build_mfc.ps1`
  - `scripts/build_release_mfc.bat`
  - `scripts/clean_mfc.bat`
- Verify `scripts\build_mfc.ps1` auto-closes running `SerialToCanIspToolMfc.exe` before build
  (or can be disabled via `-CloseRunningTool $false`).
- Verify `scripts\clean_mfc.bat` does not remove:
  - executable and INI files
  - required DLLs, data, logs, firmware images, and unknown sentinel files
- Verify compiler/linker intermediates are removed.

Result: PASS / FAIL

==================================================
Section 2 — PC Tool Core Requirements
==================================================

[PC-01] MFC executable baseline
- Build x64 Release successfully.
- EXE runs on clean Windows without Python runtime.

Result: PASS / FAIL

[PC-02] No extra driver install path
- Verify selected transport mode uses Windows built-in stack where applicable.

Result: PASS / FAIL

[PC-03] Required actions available
- UI provides:
  - Open COM
  - Load Binary
  - Set CAN Bitrate
  - Enter Bootloader
  - Erase
  - Program
  - Verify
  - Run

Result: PASS / FAIL

[PC-04] Progress and logging
- Verify program flow updates progress bar.
- Verify all major command/result paths write to log window.

Result: PASS / FAIL

[PC-05] Program flow status
- Verify `Program` uses real UART command path (not stub simulation).
- Verify progress updates by ACKed block count.

Result: PASS / FAIL

[PC-06] App icon consistency
- Verify app icon shows white `C` on light orange background in:
  - window title bar (left-top)
  - taskbar
  - File Explorer executable icon

Result: PASS / FAIL

==================================================
Section 3 — Protocol / Transport Validation
==================================================

[LINK-01] UART baudrate options
- Verify selectable baudrates include:
  - `115200`
  - `460800`
  - `921600`

Result: PASS / FAIL

[LINK-02] Block pipeline behavior
- Verify PC can pre-send 2~4 blocks without waiting each block ACK.

Result: PASS / FAIL

[LINK-03] ACK/retry handling
- Verify timeout/NAK can trigger retry policy and log cause.

Result: PASS / FAIL

[LINK-04] Framing / CRC validation
- Verify frame layout:
  - `55 AA` + `Version/Type/Seq/Cmd/Status/Len` + `HeaderCRC16` + `Payload` + `PayloadCRC16`
- Verify CRC mismatch frame is rejected by receiver side.

Result: PASS / FAIL

[LINK-05] Command response matching
- Verify request/response pairing uses `Seq + Cmd`.
- Verify stale/out-of-order response does not corrupt current command flow.

Result: PASS / FAIL

==================================================
Section 4 — EVB Bridge Expectations
==================================================

[BR-01] Multi-buffer bridge
- Verify EVB bridge supports concurrent states:
  - UART RX ingest
  - CAN TX forwarding
  - ACK/Retry waiting queue

Result: PASS / FAIL

[BR-02] CAN frame segmentation
- Verify ISP payload is split/packed into CAN 8-byte frames correctly.

Result: PASS / FAIL

[BR-03] End-to-end ISP flow
- Verify target update path works:
  - Enter -> Erase -> Program -> Verify -> Run

Result: PASS / FAIL

[BR-04] Program pipeline runtime
- Verify with prefetch `2/3/4` all can run and update progress by ACKed blocks.
- Verify per-block ACK timeout triggers resend and does not deadlock.
- Verify block retry reaches `max_retries` then aborts with explicit error log.

Result: PASS / FAIL

[BR-05] Duplicate request replay + readback policy
- Verify same request (`Seq/Cmd/Payload`) retransmit does not re-execute command and gets cached response replay.
- Verify `CMD_VERIFY_READBACK_BLOCK (0x27)` is disabled and returns `BadCommand`.

Result: PASS / FAIL

[BR-06] Optional per-word ACK trace
- When PC `Log CAN TX/RX` is enabled, verify EVB returns successful `ProgramBlock` payload containing per-word ACK readback data.
- Verify tool log prints:
  - `DBG RX ACKWORD ADDR=0x... EXP=0x... ACK=0x...`
- Verify `ProgramEnd` can additionally print compact page-first-word summary records:
  - `DBG PAGE0 ADDR=0x... TX=0x... ACK=0x... COUNT=tx/ack`
- Verify disabling `Log CAN TX/RX` returns the original lightweight successful `ProgramBlock` response.

Result: PASS / FAIL

[BR-06] Config/Option-byte path disabled in bridge scope
- Verify `IspReadConfig (0x34) / IspUpdateConfig (0x35) / IspCanReadConfig (0x40)` return `BadCommand`.
- Verify `IspRaw32` blocks config opcodes:
  - `0xA3000000`
  - `0xA1000000`, `0xA2000000`, `0xE0000000`, `0xE1000000`
- Verify update flow (`SetCanBitrate -> Enter -> Erase -> Program -> Verify -> Run`) unaffected.
- Verify `CMD_ERASE (0x21)` does not send `A3000000` (no-op ACK only for current ISP_CAN target profile).

Result: PASS / FAIL

[BR-07] Abstraction layer rule (no direct UARTx/CANx in bridge flow modules)
- Verify `bridge_host_link.c/.h` and `bridge_nuvoisp_can.c/.h` do not directly operate fixed peripheral instances (`UART0/UART1/CAN0/...`).
- Verify hardware-specific binding is isolated in:
  - `bridge_board_config.h`
  - `bridge_board_config_<platform>.h`
  - `bridge_can_backend.h`
  - `bridge_can_backend_<platform>.h`
  - `bridge_hw_abstraction.c/.h`
- Verify on same MCU family changing UART/CAN port/pin can be done by editing `bridge_board_config_<platform>.h` only, without touching upper bridge flow logic.
- Verify cross-family CAN IP / driver changes can be isolated to `bridge_can_backend_<platform>.h` without touching upper bridge flow logic.

Result: PASS / FAIL

[BR-08] Connect/run anti-flood policy
- Verify once bootloader connected, EVB responds `EnterBootloader` from cache and does not keep issuing connect command to target.
- Verify `RUN_APROM` keeps single-shot behavior in same session.
- Verify `RUN_APROM` path stops EVB CAN before UART OK flush and chip reset; target must not observe repeated `AB000000` after the first run command.
- Verify `RUN_APROM` hard-stop path does not stall in CAN shutdown; host must not end with `Run failed: Response timeout`.
- Verify current best-known bridge baseline keeps page-boundary controls enabled:
  - pre-TX delay
  - post-ACK delay
  - duplicate guard
  - TX cleanup slot
- Verify current A/B delay value is `100ms` for both pre-TX and post-ACK page-boundary delay paths.
- Verify current M0A21/M0A23 ISP_CAN target page-boundary basis is `512 bytes`.
- Verify current first-word erase guard width is `4 bytes` so worst-case timeout is only applied to the first word at each `512-byte` boundary.
- Verify `ProgramBegin` optional timeout extension is accepted and used as the page-boundary first-word ACK timeout override.
- Verify the same baseline is propagated to other maintained bridge EVB template projects before claiming cross-platform consistency.

Result: PASS / FAIL

[BR-09] Duplicate address guard in ProgramBlock write path
- Verify EVB internal retry is disabled (`CAN_MAX_RETRY=1`) so it does not resend same target address internally.
- Verify under normal programming target boot log does not show frequent duplicate write addresses.
- Verify page-boundary duplicate-guard / TX-cleanup are active in the current
  bridge baseline.

Result: PASS / FAIL

[BR-10] EVB CAN timeout/retry policy (single-target bus)
- Verify EVB firmware constants:
  - `CAN_CMD_TIMEOUT_MS = 3000`
  - `CAN_ACK_TIMEOUT_MS = 800`
  - `CAN_MAX_RETRY = 1`
- Verify EVB no longer sends repeated same-address write due internal retry loop.
- Verify EVB TX interrupt clear path does not call vendor helper
  `CAN_CLR_INT_PENDING_BIT()` on TX message objects.
- Verify TX-object interrupt clear uses a local "clear IntPnd only" path
  without `TXRQSTNEWDAT`, so one logical request does not replay as many
  repeated `0x487` frames on bus.
- Verify EVB TX message objects are configured without `TXIE`; TX completion
  must be polling-based via `TXREQ`, not TX-completion interrupts.

Result: PASS / FAIL

[BR-11] Target log parity with reference `teraterm.log`
- Verify target-side command sequence is close to reference pattern:
  - connect phase includes `B1`
  - program begin includes repeated `A200`
  - program phase is ascending APROM word-address commands
  - end phase includes `AB`

Result: PASS / FAIL

==================================================
Section 5 — Go-Live Bring-Up
==================================================

[GL-01] End-to-end flash update on real hardware
- Execute and log complete flow:
  - `SetCanBitrate -> Enter -> Erase -> Program -> Verify -> Run`
- Confirm target MCU runs updated firmware after `Run`.

Result: PASS / FAIL

[GL-02] Retry/resend robustness
- During programming, inject response loss/timeout scenarios.
- Verify:
  - block retry works
  - duplicate request replay prevents duplicated command side effects
  - failure is reported with explicit status/log when retry budget is exhausted

Result: PASS / FAIL

[GL-03] Verify mode behavior
- Validate readback policy:
  - `VerifyReadbackBlock` disabled by design (`BadCommand`).

Result: PASS / FAIL

[GL-04] Port/pin switch smoke test (same MCU family)
- Change only `bridge_board_config.h` to another supported UART/CAN mapping.
- Rebuild and run a smoke test (Ping/Enter/Run or full update flow).
- Confirm no changes needed in upper bridge flow modules.

Result: PASS / FAIL

==================================================
Conclusion
==================================================

- Any FAIL must include reason and planned fix file(s).
- No silent skip.




- ?? BSP ????????????? MCU ?????????
  - `bridge_board_config.h`
  - `bridge_board_config_<platform>.h`
  - `bridge_can_backend.h`
  - `bridge_can_backend_<platform>.h`
- ????? BSP ????????????? `bridge_board_config_*` ? `bridge_can_backend_*` ???
- ?????? golden sample?????????????????????????? BSP ??????
