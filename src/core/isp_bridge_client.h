#pragma once

#include <cstdint>
#include <functional>
#include <string>
#include <vector>

#include "bridge_protocol.h"
#include "serial_port.h"

namespace serial_can::core {

struct ProgramProgress {
    std::uint32_t total_blocks = 0;
    std::uint32_t acked_blocks = 0;
    std::uint32_t last_acked_block = 0;
};

struct IspClientOptions {
    std::uint32_t command_timeout_ms = 800;
    std::uint32_t ack_timeout_ms = 1200;
    std::uint32_t max_retries = 1;
    std::uint32_t program_block_size = 64;
    std::uint32_t prefetch_window = 1; // strict mode uses single in-flight block
    bool trace_expected_addr_data = false;
    bool trace_can_tx_rx = false;
};

struct ProgramCanSequenceSummary {
    bool valid = false;
    std::uint32_t a2_warmup_count = 0;
    std::uint32_t address_word_count = 0;
    std::uint32_t first_address = 0;
    std::uint32_t last_address = 0;
    std::uint32_t consecutive_duplicate_address = 0;
    std::uint32_t ab_count = 0;
    std::uint64_t address_to_last_ack_ms = 0;
};

class IspBridgeClient {
public:
    IspBridgeClient();

    void SetPort(SerialPort* port) { port_ = port; }
    void SetOptions(const IspClientOptions& options);
    const IspClientOptions& Options() const;

    bool SetCanBitrate(const std::wstring& bitrate_text, std::wstring* error);
    bool EnterBootloader(std::wstring* error);
    bool Erase(std::wstring* error);
    bool Verify(std::uint32_t image_crc32, std::uint32_t image_size, std::wstring* error);
    bool Run(std::wstring* error);
    bool IspHostCmdNoPayload(Command cmd, std::vector<std::uint8_t>* response_payload, std::wstring* error);
    bool IspHostCmdAddr(Command cmd, std::uint32_t address, std::vector<std::uint8_t>* response_payload, std::wstring* error);
    bool IspHostCmdAddrData(Command cmd,
                            std::uint32_t address,
                            std::uint32_t data,
                            std::vector<std::uint8_t>* response_payload,
                            std::wstring* error);
    bool IspRaw32(std::uint32_t cmd32,
                  std::uint32_t data32,
                  std::uint16_t timeout_ms,
                  std::uint8_t retry_count,
                  std::uint8_t flags,
                  std::vector<std::uint8_t>* response_payload,
                  std::wstring* error);

    bool ProgramImage(const std::vector<std::uint8_t>& image,
                      const std::function<void(const ProgramProgress&)>& on_progress,
                      const std::function<void(const std::wstring&)>& on_trace,
                      const std::function<void()>& on_yield,
                      std::wstring* error);
    bool VerifyReadbackImage(const std::vector<std::uint8_t>& image,
                             const std::function<void(const ProgramProgress&)>& on_progress,
                             const std::function<void(const std::wstring&)>& on_trace,
                             const std::function<void()>& on_yield,
                             std::wstring* error);
    const ProgramCanSequenceSummary& LastProgramCanSummary() const { return last_program_can_summary_; }

    static std::uint32_t Crc32(const std::uint8_t* data, std::size_t len);

private:
    struct Response {
        std::uint16_t seq = 0;
        std::uint8_t cmd = 0;
        Status status = Status::InternalError;
        std::vector<std::uint8_t> payload;
    };

    bool SendCommandWithRetry(Command cmd,
                              const std::vector<std::uint8_t>& payload,
                              Response* response,
                              std::wstring* error);

    bool SendFrameAndWait(std::uint16_t seq,
                          Command cmd,
                          const std::vector<std::uint8_t>& payload,
                          Response* response,
                          std::wstring* error,
                          std::uint32_t timeout_ms);

    bool ReceiveFrame(Response* response, std::uint32_t timeout_ms, std::wstring* error);
    bool SendFrame(std::uint16_t seq, Command cmd, const std::vector<std::uint8_t>& payload, std::wstring* error);

    std::vector<std::uint8_t> MakeProgramBeginPayload(std::uint32_t image_size,
                                                      std::uint32_t image_crc32,
                                                      std::uint16_t block_size,
                                                      std::uint8_t window) const;
    std::vector<std::uint8_t> MakeProgramBlockPayload(std::uint32_t block_index,
                                                      std::uint32_t offset,
                                                      const std::uint8_t* block,
                                                      std::uint16_t block_len) const;

    static void PutLe16(std::vector<std::uint8_t>* out, std::uint16_t v);
    static void PutLe32(std::vector<std::uint8_t>* out, std::uint32_t v);
    static std::uint32_t ReadLe32(const std::uint8_t* p);
    static std::uint32_t ParseBitrate(const std::wstring& bitrate_text);

private:
    SerialPort* port_ = nullptr;
    IspClientOptions options_{};
    std::uint16_t next_seq_ = 1;
    FrameStreamParser parser_;
    ProgramCanSequenceSummary last_program_can_summary_{};
};

} // namespace serial_can::core

