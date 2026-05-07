#pragma once

#include <cstddef>
#include <cstdint>
#include <vector>

namespace serial_can::core {

constexpr std::uint8_t kFrameSof0 = 0x55;
constexpr std::uint8_t kFrameSof1 = 0xAA;
constexpr std::uint8_t kFrameVersion = 0x01;

enum class FrameType : std::uint8_t {
    Request = 0x10,
    Response = 0x20,
};

enum class Command : std::uint8_t {
    Ping = 0x01,
    SetCanBitrate = 0x10,
    EnterBootloader = 0x20,
    Erase = 0x21,
    ProgramBegin = 0x22,
    ProgramBlock = 0x23,
    ProgramEnd = 0x24,
    Verify = 0x25,
    Run = 0x26,
    VerifyReadbackBlock = 0x27,

    IspGetVersion = 0x30,
    IspConnect = 0x31,
    IspSyncPackNo = 0x32,
    IspGetDeviceId = 0x33,
    IspReadConfig = 0x34,
    IspUpdateConfig = 0x35,
    IspUpdateApromWord = 0x36,
    IspUpdateDataflashWord = 0x37,
    IspEraseAll = 0x38,
    IspRunAprom = 0x39,
    IspRunLdrom = 0x3A,
    IspReset = 0x3B,
    IspResendPacket = 0x3C,
    IspEraseSpiFlash = 0x3D,
    IspUpdateSpiFlashWord = 0x3E,
    IspCanGetDeviceId = 0x3F,
    IspCanReadConfig = 0x40,
    IspCanRunAprom = 0x41,
    IspRaw32 = 0x42,
};

enum class Status : std::uint8_t {
    Ok = 0x00,
    Busy = 0x01,
    BadCommand = 0x02,
    BadArgument = 0x03,
    CrcError = 0x04,
    SequenceError = 0x05,
    VerifyFailed = 0x06,
    Timeout = 0x07,
    InternalError = 0x08,
};

struct Frame {
    FrameType type = FrameType::Request;
    std::uint16_t seq = 0;
    std::uint8_t cmd = 0;
    std::uint8_t status = 0;
    std::vector<std::uint8_t> payload;
};

std::uint16_t Crc16Ccitt(const std::uint8_t* data, std::size_t len);
std::vector<std::uint8_t> EncodeFrame(const Frame& frame);
bool DecodeFrame(const std::vector<std::uint8_t>& bytes, Frame* out);

class FrameStreamParser {
public:
    void Push(const std::uint8_t* data, std::size_t len);
    bool TryPop(Frame* out);
    void Clear();

private:
    std::vector<std::uint8_t> buffer_;
};

} // namespace serial_can::core
