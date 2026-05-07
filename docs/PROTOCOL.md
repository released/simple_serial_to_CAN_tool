# PC <-> EVB Protocol (UART Serial-to-CAN ISP)

Version: `1`

## Frame Format

- Byte 0: `SOF0 = 0x55`
- Byte 1: `SOF1 = 0xAA`
- Byte 2: `Version` (`0x01`)
- Byte 3: `FrameType`
  - `0x10` Request
  - `0x20` Response
- Byte 4..5: `Seq` (LE, uint16)
- Byte 6: `Cmd` (uint8)
- Byte 7: `Status` (uint8)
  - Request 固定填 `0x00`
  - Response 由 EVB 回覆狀態碼
- Byte 8..9: `PayloadLen` (LE, uint16)
- Byte 10..11: `HeaderCRC16` (CRC-16/CCITT-FALSE over byte 2..9)
- Byte 12..(12+PayloadLen-1): `Payload`
- Last 2 bytes: `PayloadCRC16` (CRC-16/CCITT-FALSE over payload)

CRC parameters:
- Poly: `0x1021`
- Init: `0xFFFF`
- RefIn/RefOut: `false`
- XorOut: `0x0000`

## Command IDs

- `0x01` `Ping`
- `0x10` `SetCanBitrate`
- `0x20` `EnterBootloader`
- `0x21` `Erase`
- `0x22` `ProgramBegin`
- `0x23` `ProgramBlock`
- `0x24` `ProgramEnd`
- `0x25` `Verify`
- `0x26` `Run`
- `0x27` `VerifyReadbackBlock`
- `0x30` `IspGetVersion`
- `0x31` `IspConnect`
- `0x32` `IspSyncPackNo`
- `0x33` `IspGetDeviceId`
- `0x34` `IspReadConfig`
- `0x35` `IspUpdateConfig`
- `0x36` `IspUpdateApromWord`
- `0x37` `IspUpdateDataflashWord`
- `0x38` `IspEraseAll`
- `0x39` `IspRunAprom`
- `0x3A` `IspRunLdrom`
- `0x3B` `IspReset`
- `0x3C` `IspResendPacket`
- `0x3D` `IspEraseSpiFlash`
- `0x3E` `IspUpdateSpiFlashWord`
- `0x3F` `IspCanGetDeviceId`
- `0x40` `IspCanReadConfig`
- `0x41` `IspCanRunAprom`
- `0x42` `IspRaw32`

## Status Codes

- `0x00` `Ok`
- `0x01` `Busy`
- `0x02` `BadCommand`
- `0x03` `BadArgument`
- `0x04` `CrcError`
- `0x05` `SequenceError`
- `0x06` `VerifyFailed`
- `0x07` `Timeout`
- `0x08` `InternalError`

## Payload Definition

### SetCanBitrate (`0x10`)
- Request payload:
  - `bitrate_bps` (uint32 LE)

### ProgramBegin (`0x22`)
- Request payload:
  - `image_size` (uint32 LE)
  - `image_crc32` (uint32 LE)
  - `block_size` (uint16 LE)
  - `window` (uint8, 2..4)
  - `flags` (uint8)
    - reserved for compatibility in current profile (ignored by EVB)

### ProgramBlock (`0x23`)
- Request payload:
  - `block_index` (uint32 LE)
  - `offset` (uint32 LE)
  - `data_len` (uint16 LE)
  - `data[data_len]`

### Verify (`0x25`)
- Request payload:
  - `image_size` (uint32 LE)
  - `image_crc32` (uint32 LE)

### VerifyReadbackBlock (`0x27`)
- Request payload:
  - `block_index` (uint32 LE)
  - `offset` (uint32 LE)
  - `data_len` (uint16 LE)
  - `data[data_len]`
- Policy:
  - current profile disabled; EVB returns `BadCommand`.

### Legacy ISP Host Command Payloads (`0x30..0x42`)
- `IspGetVersion / IspConnect / IspSyncPackNo / IspGetDeviceId / IspEraseAll / IspRunAprom / IspRunLdrom / IspReset / IspResendPacket / IspEraseSpiFlash / IspCanGetDeviceId / IspCanRunAprom`
  - Request payload: empty
- `IspReadConfig / IspCanReadConfig`
  - Request payload:
    - `address` (uint32 LE)
- `IspUpdateConfig / IspUpdateApromWord / IspUpdateDataflashWord / IspUpdateSpiFlashWord`
  - Request payload:
    - `address` (uint32 LE)
    - `data` (uint32 LE)
- `IspRaw32`
  - Request payload format A (8 bytes):
    - `cmd32` (uint32 LE)
    - `data32` (uint32 LE)
  - Request payload format B (12 bytes):
    - `cmd32` (uint32 LE)
    - `data32` (uint32 LE)
    - `timeout_ms` (uint16 LE, 0 means default)
    - `retry_count` (uint8, 0 means default)
    - `flags` (uint8)
      - bit0=`1`: fire-and-forget (send only, no ACK wait)
- 對於會等待 ACK 的命令，Response payload 為 `ack_data` (uint32 LE)。

### Scope Note (Current Bridge Policy)
- 本專案目前目標是「以 EVB 作為更新媒介」，僅保證更新流程：
  - `SetCanBitrate -> Enter -> Erase -> Program -> Verify -> Run`
- `CONFIG / Option Byte` 相關命令目前在 EVB firmware 明確禁用，回覆 `BadCommand`：
  - `IspReadConfig (0x34)`
  - `IspUpdateConfig (0x35)`
  - `IspCanReadConfig (0x40)`
- `IspRaw32` 也會阻擋下列 config opcode：
  - `0xA3000000` (`ERASE_ALL`)
  - `0xA1000000` (`UPDATE_CONFIG`)
  - `0xA2000000` (`READ_CONFIG`)
  - `0xE0000000` (`READ_CONFIG_EXT`)
  - `0xE1000000` (`UPDATE_CONFIG_EXT`)
- readback verify 補充限制：
  - `CMD_VERIFY_READBACK_BLOCK (0x27)` 目前禁用（回 `BadCommand`）。
- erase 行為補充限制（target `ISP_CAN` profile）：
  - EVB 不轉發 `A3000000 (ERASE_ALL)`。
  - `CMD_ERASE (0x21)` 為 no-op（回 `OK`），target 於 word-write page boundary 自行執行 page erase。
- run 行為補充限制（target `ISP_CAN` profile）：
  - `RUN_APROM (0xAB000000)` 由 EVB 單次轉發；同一 session 內重複 run 請求不重複送 `AB`。
  - session 於 `EnterBootloader` 成功或 `ProgramBegin` 時重置。

## ACK/Retry and Prefetch Window

- `SetCanBitrate/Enter/Erase/Verify/Run`:
  - command timeout with retry (`max_retries`)
- `ProgramBlock`:
  - host 維持 in-flight window `2~4` blocks
  - 以 `Seq` 對應每個 block ACK
  - 超過 `ack_timeout_ms` 未收到 ACK 即重送該 block
  - 單一 block 超過 `max_retries` 視為失敗
  - EVB 若收到完全相同請求 (`seq/cmd/payload_crc`) 且已有快取回覆，會直接重送回覆，避免重複執行命令
- `0x30..0x42` 命令:
  - EVB 會直接依 payload 轉成 CAN `cmd32+data32` host 行為
  - 不檢查 target 是否實作該命令格式
- EVB SRAM 受限版本限制:
  - `Host payload <= 96 bytes`
  - `ProgramBlock data_len <= 80 bytes`
- EVB CAN tuning (current firmware constants):
  - `CAN_CMD_TIMEOUT_MS = 3000`
  - `CAN_ERASE_TIMEOUT_MS = 10000`
  - `CAN_ACK_TIMEOUT_MS = 800`
  - `CAN_MAX_RETRY = 1`
- 預設實作：
  - `program_block_size = 64`
  - `prefetch_window = 4`
  - `ack_timeout_ms = 1200`
  - `max_retries = 2`
