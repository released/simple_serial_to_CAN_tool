#include "isp_bridge_client.h"

#include <algorithm>
#include <cstring>
#include <deque>
#include <map>
#include <sstream>

namespace serial_can::core {

namespace {
constexpr std::uint32_t kProgramBeginWarmupA2Count = 14u;
constexpr std::uint8_t kProgramBeginFlagPageDiag = 0x04u;

std::wstring StatusText(Status s) {
    switch (s) {
        case Status::Ok: return L"OK";
        case Status::Busy: return L"BUSY";
        case Status::BadCommand: return L"BAD_COMMAND";
        case Status::BadArgument: return L"BAD_ARGUMENT";
        case Status::CrcError: return L"CRC_ERROR";
        case Status::SequenceError: return L"SEQUENCE_ERROR";
        case Status::VerifyFailed: return L"VERIFY_FAILED";
        case Status::Timeout: return L"TIMEOUT";
        case Status::InternalError: return L"INTERNAL_ERROR";
        default: return L"UNKNOWN";
    }
}

std::wstring HexBytes(const std::vector<std::uint8_t>& data, std::size_t max_len) {
    static const wchar_t* kHex = L"0123456789ABCDEF";
    std::wstring out;
    const std::size_t n = (std::min)(data.size(), max_len);
    out.reserve(n * 3);
    for (std::size_t i = 0; i < n; ++i) {
        const std::uint8_t v = data[i];
        out.push_back(kHex[(v >> 4) & 0x0F]);
        out.push_back(kHex[v & 0x0F]);
        if (i + 1 < n) {
            out.push_back(L' ');
        }
    }
    if (data.size() > max_len) {
        out += L" ...";
    }
    return out;
}

std::wstring Hex32(std::uint32_t v) {
    wchar_t buf[16] = {};
    swprintf_s(buf, L"%08X", static_cast<unsigned>(v));
    return std::wstring(buf);
}

std::wstring ProgramDiagReasonText(std::uint8_t reason) {
    switch (reason) {
        case 1u: return L"TX_FAIL";
        case 2u: return L"ACK_TIMEOUT";
        case 3u: return L"ACK_MISMATCH";
        case 4u: return L"PAGE_REPEAT";
        case 5u: return L"TX_CLEANUP_FAIL";
        default: return L"UNKNOWN";
    }
}

std::wstring ConnectDiagPhaseText(std::uint8_t phase) {
    switch (phase) {
        case 1u: return L"B1_GET_DEVICEID";
        case 2u: return L"A2_WARMUP";
        default: return L"UNKNOWN";
    }
}

void TraceProgramEndPageDiag(const std::vector<std::uint8_t>& payload,
                             const std::function<void(const std::wstring&)>& trace) {
    if (payload.empty() || !trace) {
        return;
    }

    const std::uint8_t count = payload[0];
    std::size_t pos = 1u;
    for (std::uint8_t i = 0; i < count; ++i) {
        if (pos + 11u > payload.size()) {
            std::wstringstream ss;
            ss << L"DBG ProgramEnd page diag malformed: payload[" << payload.size()
               << L"]=" << HexBytes(payload, 40);
            trace(ss.str());
            return;
        }

        const std::uint16_t addr16 = static_cast<std::uint16_t>(payload[pos] |
                                                                 (static_cast<std::uint16_t>(payload[pos + 1u]) << 8));
        const std::uint32_t tx_word = static_cast<std::uint32_t>(payload[pos + 2u]) |
                                      (static_cast<std::uint32_t>(payload[pos + 3u]) << 8) |
                                      (static_cast<std::uint32_t>(payload[pos + 4u]) << 16) |
                                      (static_cast<std::uint32_t>(payload[pos + 5u]) << 24);
        const std::uint32_t ack_word = static_cast<std::uint32_t>(payload[pos + 6u]) |
                                       (static_cast<std::uint32_t>(payload[pos + 7u]) << 8) |
                                       (static_cast<std::uint32_t>(payload[pos + 8u]) << 16) |
                                       (static_cast<std::uint32_t>(payload[pos + 9u]) << 24);
        const std::uint8_t counts = payload[pos + 10u];
        const std::uint8_t tx_count = static_cast<std::uint8_t>(counts & 0x0Fu);
        const std::uint8_t ack_count = static_cast<std::uint8_t>((counts >> 4) & 0x0Fu);

        std::wstringstream ss;
        ss << L"DBG PAGE0 ADDR=0x" << Hex32(addr16)
           << L" TX=0x" << Hex32(tx_word)
           << L" ACK=0x" << Hex32(ack_word)
           << L" COUNT=" << static_cast<unsigned>(tx_count)
           << L"/" << static_cast<unsigned>(ack_count);
        trace(ss.str());

        pos += 11u;
    }
}

} // namespace

IspBridgeClient::IspBridgeClient() = default;

void IspBridgeClient::SetOptions(const IspClientOptions& options) {
    options_ = options;
    if (options_.prefetch_window == 0) {
        options_.prefetch_window = 1;
    }
    if (options_.prefetch_window > 4) {
        options_.prefetch_window = 4;
    }
    if (options_.program_block_size < 16) {
        options_.program_block_size = 16;
    }
    if (options_.program_block_size > 80) {
        options_.program_block_size = 80;
    }
    if (options_.max_retries == 0) {
        options_.max_retries = 1;
    }
}

const IspClientOptions& IspBridgeClient::Options() const {
    return options_;
}

std::uint32_t IspBridgeClient::ParseBitrate(const std::wstring& bitrate_text) {
    if (bitrate_text == L"125K") return 125000;
    if (bitrate_text == L"250K") return 250000;
    if (bitrate_text == L"500K") return 500000;
    if (bitrate_text == L"800K") return 800000;
    if (bitrate_text == L"1M") return 1000000;
    return 500000;
}

bool IspBridgeClient::SetCanBitrate(const std::wstring& bitrate_text, std::wstring* error) {
    std::vector<std::uint8_t> payload;
    PutLe32(&payload, ParseBitrate(bitrate_text));
    Response rsp;
    return SendCommandWithRetry(Command::SetCanBitrate, payload, &rsp, error);
}

bool IspBridgeClient::EnterBootloader(std::wstring* error) {
    Response rsp;
    const std::uint16_t seq = next_seq_++;
    return SendFrameAndWait(seq, Command::EnterBootloader, {}, &rsp, error, options_.command_timeout_ms);
}

bool IspBridgeClient::Erase(std::wstring* error) {
    Response rsp;
    return SendCommandWithRetry(Command::Erase, {}, &rsp, error);
}

bool IspBridgeClient::Verify(std::uint32_t image_crc32, std::uint32_t image_size, std::wstring* error) {
    std::vector<std::uint8_t> payload;
    PutLe32(&payload, image_size);
    PutLe32(&payload, image_crc32);

    Response rsp;
    return SendCommandWithRetry(Command::Verify, payload, &rsp, error);
}

bool IspBridgeClient::Run(std::wstring* error) {
    Response rsp;
    return SendCommandWithRetry(Command::Run, {}, &rsp, error);
}

bool IspBridgeClient::IspHostCmdNoPayload(Command cmd,
                                          std::vector<std::uint8_t>* response_payload,
                                          std::wstring* error) {
    Response rsp;
    if (!SendCommandWithRetry(cmd, {}, &rsp, error)) {
        return false;
    }
    if (response_payload != nullptr) {
        *response_payload = std::move(rsp.payload);
    }
    return true;
}

bool IspBridgeClient::IspHostCmdAddr(Command cmd,
                                     std::uint32_t address,
                                     std::vector<std::uint8_t>* response_payload,
                                     std::wstring* error) {
    std::vector<std::uint8_t> payload;
    PutLe32(&payload, address);

    Response rsp;
    if (!SendCommandWithRetry(cmd, payload, &rsp, error)) {
        return false;
    }
    if (response_payload != nullptr) {
        *response_payload = std::move(rsp.payload);
    }
    return true;
}

bool IspBridgeClient::IspHostCmdAddrData(Command cmd,
                                         std::uint32_t address,
                                         std::uint32_t data,
                                         std::vector<std::uint8_t>* response_payload,
                                         std::wstring* error) {
    std::vector<std::uint8_t> payload;
    PutLe32(&payload, address);
    PutLe32(&payload, data);

    Response rsp;
    if (!SendCommandWithRetry(cmd, payload, &rsp, error)) {
        return false;
    }
    if (response_payload != nullptr) {
        *response_payload = std::move(rsp.payload);
    }
    return true;
}

bool IspBridgeClient::IspRaw32(std::uint32_t cmd32,
                               std::uint32_t data32,
                               std::uint16_t timeout_ms,
                               std::uint8_t retry_count,
                               std::uint8_t flags,
                               std::vector<std::uint8_t>* response_payload,
                               std::wstring* error) {
    std::vector<std::uint8_t> payload;
    PutLe32(&payload, cmd32);
    PutLe32(&payload, data32);
    PutLe16(&payload, timeout_ms);
    payload.push_back(retry_count);
    payload.push_back(flags);

    Response rsp;
    if (!SendCommandWithRetry(Command::IspRaw32, payload, &rsp, error)) {
        return false;
    }
    if (response_payload != nullptr) {
        *response_payload = std::move(rsp.payload);
    }
    return true;
}

bool IspBridgeClient::ProgramImage(const std::vector<std::uint8_t>& image,
                                   const std::function<void(const ProgramProgress&)>& on_progress,
                                   const std::function<void(const std::wstring&)>& on_trace,
                                   const std::function<void()>& on_yield,
                                   std::wstring* error) {
    const auto trace = [&on_trace](const std::wstring& text) {
        if (on_trace) {
            on_trace(text);
        }
    };

    if (port_ == nullptr || !port_->IsOpen()) {
        if (error != nullptr) {
            *error = L"Serial port is not open.";
        }
        return false;
    }
    if (image.empty()) {
        if (error != nullptr) {
            *error = L"Image is empty.";
        }
        return false;
    }

    last_program_can_summary_ = {};

    const std::uint16_t block_size = static_cast<std::uint16_t>(options_.program_block_size);
    const std::uint32_t window = 1u;
    const std::uint32_t image_size = static_cast<std::uint32_t>(image.size());
    const std::uint32_t image_crc32 = Crc32(image.data(), image.size());
    const std::uint32_t total_blocks = (image_size + block_size - 1u) / block_size;
    const std::uint32_t total_words = (image_size + 3u) / 4u;

    Response begin_rsp;
    if (!SendCommandWithRetry(Command::ProgramBegin,
                              MakeProgramBeginPayload(image_size, image_crc32, block_size, static_cast<std::uint8_t>(window)),
                              &begin_rsp,
                              error)) {
        return false;
    }
    {
        std::wstringstream ss;
        ss << L"DBG ProgramBegin OK: seq=" << begin_rsp.seq
           << L", image_size=" << image_size
           << L", block_size=" << block_size
           << L", prefetch=" << window
           << L", crc32=0x" << std::hex << std::uppercase << image_crc32;
        trace(ss.str());
    }

    last_program_can_summary_.a2_warmup_count = kProgramBeginWarmupA2Count;
    last_program_can_summary_.address_word_count = total_words;
    last_program_can_summary_.first_address = 0u;
    last_program_can_summary_.last_address = (total_words == 0u) ? 0u : ((total_words - 1u) * 4u);
    last_program_can_summary_.consecutive_duplicate_address = 0u;
    last_program_can_summary_.ab_count = 1u;
    ULONGLONG first_addr_tick = 0u;
    ULONGLONG last_ack_tick = 0u;

    ProgramProgress progress;
    progress.total_blocks = total_blocks;
    progress.acked_blocks = 0;
    progress.last_acked_block = 0;
    if (on_progress) {
        on_progress(progress);
    }

    for (std::uint32_t block = 0; block < total_blocks; ++block) {
        if (on_yield) {
            on_yield();
        }

        const std::uint32_t offset = block * block_size;
        const std::uint32_t remain = image_size - offset;
        const std::uint16_t len = static_cast<std::uint16_t>((std::min)(static_cast<std::uint32_t>(block_size), remain));
        if (first_addr_tick == 0u) {
            first_addr_tick = GetTickCount64();
        }
        const std::uint16_t seq = next_seq_++;
        const auto payload = MakeProgramBlockPayload(block, offset, image.data() + offset, len);

        if (options_.trace_expected_addr_data) {
            for (std::uint32_t i = 0; i < len; i += 4u) {
                std::uint32_t word = 0xFFFFFFFFu;
                const std::uint32_t copy_len = (std::min)(4u, static_cast<std::uint32_t>(len - i));
                std::memcpy(&word, image.data() + offset + i, copy_len);
                const std::uint32_t addr = offset + i;
                trace(L"DBG EXP ADDR=0x" + Hex32(addr) + L" DATA=0x" + Hex32(word));
            }
        }

        if (!SendFrame(seq, Command::ProgramBlock, payload, error)) {
            if (options_.trace_can_tx_rx) {
                std::wstringstream ss;
                ss << L"DBG TX ProgramBlock failed: idx=" << block
                   << L", seq=" << seq
                   << L", off=" << offset
                   << L", len=" << len;
                trace(ss.str());
            }
            return false;
        }
        if (options_.trace_can_tx_rx) {
            std::wstringstream ss;
            ss << L"DBG TX ProgramBlock: idx=" << block
               << L", seq=" << seq
               << L", off=" << offset
               << L", len=" << len
               << L", inflight=1";
            trace(ss.str());
        }

        for (;;) {
            Response rsp;
            std::wstring rx_error;
            const bool got = ReceiveFrame(&rsp, 25, &rx_error);
            if (!got) {
                if (!rx_error.empty() && rx_error != L"Read timeout.") {
                    if (error != nullptr) {
                        *error = rx_error;
                    }
                    trace(L"DBG ReceiveFrame error: " + rx_error);
                    return false;
                }
                if (on_yield) {
                    on_yield();
                }
                continue;
            }

            if (rsp.cmd != static_cast<std::uint8_t>(Command::ProgramBlock)) {
                if (options_.trace_can_tx_rx) {
                    std::wstringstream ss;
                    ss << L"DBG RX ignored: cmd=0x" << std::hex << std::uppercase << static_cast<unsigned>(rsp.cmd)
                       << L", seq=" << std::dec << rsp.seq
                       << L", status=" << StatusText(rsp.status);
                    trace(ss.str());
                }
                continue;
            }

            if (rsp.seq != seq) {
                if (options_.trace_can_tx_rx) {
                    std::wstringstream ss;
                    ss << L"DBG RX ProgramBlock unknown seq: seq=" << rsp.seq
                       << L", status=" << StatusText(rsp.status);
                    if (!rsp.payload.empty()) {
                        ss << L", payload[" << rsp.payload.size() << L"]=" << HexBytes(rsp.payload, 24);
                    }
                    trace(ss.str());
                }
                continue;
            }

            if (rsp.status != Status::Ok) {
                std::wstringstream ss;
                ss << L"Program block " << block
                   << L" failed. status=" << StatusText(rsp.status)
                   << L", seq=" << seq
                   << L", offset=" << offset
                   << L", len=" << len;
                if (rsp.payload.size() >= 13u) {
                    const std::uint32_t fail_addr = ReadLe32(&rsp.payload[0]);
                    const std::uint32_t fail_expected = ReadLe32(&rsp.payload[4]);
                    const std::uint32_t fail_observed = ReadLe32(&rsp.payload[8]);
                    const bool has_last_rx_cmd = (rsp.payload.size() >= 17u);
                    const bool has_last_tx = (rsp.payload.size() >= 25u);
                    const std::uint8_t fail_reason = rsp.payload[12];
                    const std::uint32_t fail_last_rx_cmd = has_last_rx_cmd ? ReadLe32(&rsp.payload[13]) : 0u;
                    const std::uint32_t fail_last_tx_cmd = has_last_tx ? ReadLe32(&rsp.payload[17]) : 0u;
                    const std::uint32_t fail_last_tx_data = has_last_tx ? ReadLe32(&rsp.payload[21]) : 0u;
                    ss << L", diag={addr=0x" << Hex32(fail_addr)
                       << L", expected=0x" << Hex32(fail_expected)
                       << L", observed=0x" << Hex32(fail_observed)
                       << L", last_rx_cmd=0x" << Hex32(fail_last_rx_cmd)
                       << L", last_tx_cmd=0x" << Hex32(fail_last_tx_cmd)
                       << L", last_tx_data=0x" << Hex32(fail_last_tx_data)
                       << L", reason=" << ProgramDiagReasonText(fail_reason)
                       << L"}";
                }
                if (!rsp.payload.empty()) {
                    ss << L", payload[" << rsp.payload.size() << L"]=" << HexBytes(rsp.payload, 24);
                }
                if (error != nullptr) {
                    *error = ss.str();
                }
                trace(L"DBG RX NACK final: " + ss.str());
                return false;
            }

            if (options_.trace_can_tx_rx) {
                std::wstringstream ss;
                ss << L"DBG RX ACK: idx=" << block
                   << L", seq=" << seq
                   << L", retry=0";
                trace(ss.str());
            }
            if (options_.trace_can_tx_rx && !rsp.payload.empty()) {
                const std::uint8_t ack_word_count = rsp.payload[0];
                const std::size_t expected_payload_size = 1u + (static_cast<std::size_t>(ack_word_count) * 4u);
                if (rsp.payload.size() == expected_payload_size) {
                    for (std::uint8_t ack_index = 0; ack_index < ack_word_count; ++ack_index) {
                        const std::uint32_t addr = offset + (static_cast<std::uint32_t>(ack_index) * 4u);
                        std::uint32_t expected_word = 0xFFFFFFFFu;
                        const std::uint32_t byte_offset = static_cast<std::uint32_t>(ack_index) * 4u;
                        const std::uint32_t copy_len = (std::min)(4u, static_cast<std::uint32_t>(len - byte_offset));
                        const std::uint32_t ack_word = ReadLe32(&rsp.payload[1u + (static_cast<std::size_t>(ack_index) * 4u)]);
                        std::memcpy(&expected_word, image.data() + offset + byte_offset, copy_len);

                        std::wstringstream ss;
                        ss << L"DBG RX ACKWORD ADDR=0x" << Hex32(addr)
                           << L" EXP=0x" << Hex32(expected_word)
                           << L" ACK=0x" << Hex32(ack_word);
                        trace(ss.str());
                    }
                } else {
                    std::wstringstream ss;
                    ss << L"DBG RX ACK payload malformed: seq=" << seq
                       << L", payload[" << rsp.payload.size() << L"]=" << HexBytes(rsp.payload, 24);
                    trace(ss.str());
                }
            }
            last_ack_tick = GetTickCount64();
            break;
        }

        progress.acked_blocks = block + 1u;
        progress.last_acked_block = block;
        if (on_progress) {
            on_progress(progress);
        }
        if ((progress.acked_blocks % 16u) == 0u || progress.acked_blocks == total_blocks) {
            std::wstringstream ss;
            ss << L"Program ACK " << progress.acked_blocks << L"/" << progress.total_blocks;
            trace(ss.str());
        }
    }

    Response end_rsp;
    if (!SendCommandWithRetry(Command::ProgramEnd, {}, &end_rsp, error)) {
        return false;
    }
    trace(L"DBG ProgramEnd OK.");
    if (options_.trace_can_tx_rx && !end_rsp.payload.empty()) {
        TraceProgramEndPageDiag(end_rsp.payload, on_trace);
    }

    last_program_can_summary_.valid = true;
    if (first_addr_tick > 0u && last_ack_tick >= first_addr_tick) {
        last_program_can_summary_.address_to_last_ack_ms = static_cast<std::uint64_t>(last_ack_tick - first_addr_tick);
    }

    return true;
}

bool IspBridgeClient::VerifyReadbackImage(const std::vector<std::uint8_t>& image,
                                          const std::function<void(const ProgramProgress&)>& on_progress,
                                          const std::function<void(const std::wstring&)>& on_trace,
                                          const std::function<void()>& on_yield,
                                          std::wstring* error) {
    const auto trace = [&on_trace](const std::wstring& text) {
        if (on_trace) {
            on_trace(text);
        }
    };

    if (port_ == nullptr || !port_->IsOpen()) {
        if (error != nullptr) {
            *error = L"Serial port is not open.";
        }
        return false;
    }
    if (image.empty()) {
        if (error != nullptr) {
            *error = L"Image is empty.";
        }
        return false;
    }

    const std::uint16_t block_size = static_cast<std::uint16_t>(options_.program_block_size);
    const std::uint32_t image_size = static_cast<std::uint32_t>(image.size());
    const std::uint32_t total_blocks = (image_size + block_size - 1u) / block_size;
    const std::uint32_t timeout_ms = (std::max)(options_.command_timeout_ms, options_.ack_timeout_ms * 6u);

    ProgramProgress progress;
    progress.total_blocks = total_blocks;
    progress.acked_blocks = 0;
    progress.last_acked_block = 0;
    if (on_progress) {
        on_progress(progress);
    }

    for (std::uint32_t block = 0; block < total_blocks; ++block) {
        if (on_yield) {
            on_yield();
        }

        const std::uint32_t offset = block * block_size;
        const std::uint32_t remain = image_size - offset;
        const std::uint16_t len = static_cast<std::uint16_t>((std::min)(static_cast<std::uint32_t>(block_size), remain));
        const auto payload = MakeProgramBlockPayload(block, offset, image.data() + offset, len);

        Response rsp;
        const std::uint16_t seq = next_seq_++;
        if (!SendFrameAndWait(seq, Command::VerifyReadbackBlock, payload, &rsp, error, timeout_ms)) {
            if (block == 0u &&
                    rsp.status == Status::VerifyFailed &&
                    rsp.payload.size() >= 16u) {
                const std::uint32_t fail_addr = ReadLe32(&rsp.payload[0]);
                const std::uint32_t fail_expected = ReadLe32(&rsp.payload[4]);
                const std::uint32_t fail_actual = ReadLe32(&rsp.payload[8]);
                const std::uint32_t fail_mask = ReadLe32(&rsp.payload[12]);

                if ((fail_addr == 0u) &&
                        (fail_actual == 0xFFFFFFFFu) &&
                        (fail_mask == 0xFFFFFFFFu)) {
                    if (error != nullptr) {
                        std::wstringstream ss;
                        ss << L"READBACK_UNSUPPORTED: second-read returned 0xFFFFFFFF at addr=0x"
                           << std::hex << std::uppercase << fail_addr
                           << L", expected=0x" << fail_expected;
                        *error = ss.str();
                    }
                    trace(L"DBG Readback verify unsupported signature detected.");
                    return false;
                }
            }
            if (error != nullptr) {
                const std::wstring base = *error;
                std::wstringstream ss;
                ss << L"Readback verify block " << block
                   << L" failed. seq=" << seq
                   << L", offset=" << offset
                   << L", len=" << len
                   << L". " << base;
                *error = ss.str();
            }
            return false;
        }

        progress.acked_blocks = block + 1u;
        progress.last_acked_block = block;
        if (on_progress) {
            on_progress(progress);
        }

        if ((block % 64u) == 0u) {
            std::wstringstream ss;
            ss << L"DBG Readback verified block " << block << L"/" << total_blocks;
            trace(ss.str());
        }
    }

    trace(L"DBG Readback verify all blocks OK.");
    return true;
}

bool IspBridgeClient::SendCommandWithRetry(Command cmd,
                                           const std::vector<std::uint8_t>& payload,
                                           Response* response,
                                           std::wstring* error) {
    for (std::uint32_t attempt = 0; attempt < options_.max_retries; ++attempt) {
        const std::uint16_t seq = next_seq_++;
        if (SendFrameAndWait(seq, cmd, payload, response, error, options_.command_timeout_ms)) {
            return true;
        }

        if (attempt + 1 >= options_.max_retries) {
            return false;
        }
    }

    if (error != nullptr && error->empty()) {
        *error = L"Command failed after retries.";
    }
    return false;
}

bool IspBridgeClient::SendFrameAndWait(std::uint16_t seq,
                                       Command cmd,
                                       const std::vector<std::uint8_t>& payload,
                                       Response* response,
                                       std::wstring* error,
                                       std::uint32_t timeout_ms) {
    if (!SendFrame(seq, cmd, payload, error)) {
        return false;
    }

    const DWORD started = GetTickCount();
    while (GetTickCount() - started < timeout_ms) {
        Response rsp;
        std::wstring rx_error;
        if (!ReceiveFrame(&rsp, 30, &rx_error)) {
            if (!rx_error.empty() && rx_error != L"Read timeout.") {
                if (error != nullptr) {
                    *error = rx_error;
                }
                return false;
            }
            continue;
        }

        if (rsp.seq != seq || rsp.cmd != static_cast<std::uint8_t>(cmd)) {
            continue;
        }

        if (response != nullptr) {
            *response = rsp;
        }

        if (rsp.status != Status::Ok) {
            if (error != nullptr) {
                std::wstringstream ss;
                ss << L"Command failed: " << StatusText(rsp.status);
                if (cmd == Command::EnterBootloader && rsp.payload.size() >= 9u) {
                    const std::uint8_t phase = rsp.payload[0];
                    const std::uint32_t last_rx_cmd = ReadLe32(&rsp.payload[1]);
                    const std::uint32_t last_rx_data = ReadLe32(&rsp.payload[5]);
                    ss << L", connect_diag={phase=" << ConnectDiagPhaseText(phase)
                       << L", last_rx_cmd=0x" << Hex32(last_rx_cmd)
                       << L", last_rx_data=0x" << Hex32(last_rx_data)
                       << L"}";
                }
                if (!rsp.payload.empty()) {
                    ss << L", payload[" << rsp.payload.size() << L"]=" << HexBytes(rsp.payload, 32);
                }
                *error = ss.str();
            }
            return false;
        }

        return true;
    }

    if (error != nullptr) {
        *error = L"Response timeout.";
    }
    return false;
}

bool IspBridgeClient::ReceiveFrame(Response* response, std::uint32_t timeout_ms, std::wstring* error) {
    if (port_ == nullptr || response == nullptr) {
        return false;
    }

    Frame parsed;
    if (parser_.TryPop(&parsed)) {
        response->seq = parsed.seq;
        response->cmd = parsed.cmd;
        response->status = static_cast<Status>(parsed.status);
        response->payload = std::move(parsed.payload);
        return true;
    }

    std::vector<std::uint8_t> chunk;
    std::wstring read_error;
    if (!port_->ReadSome(&chunk, 512, timeout_ms, &read_error)) {
        if (error != nullptr) {
            *error = read_error;
        }
        return false;
    }

    parser_.Push(chunk.data(), chunk.size());

    if (!parser_.TryPop(&parsed)) {
        if (error != nullptr) {
            error->clear();
        }
        return false;
    }

    response->seq = parsed.seq;
    response->cmd = parsed.cmd;
    response->status = static_cast<Status>(parsed.status);
    response->payload = std::move(parsed.payload);
    return true;
}

bool IspBridgeClient::SendFrame(std::uint16_t seq,
                                Command cmd,
                                const std::vector<std::uint8_t>& payload,
                                std::wstring* error) {
    if (port_ == nullptr || !port_->IsOpen()) {
        if (error != nullptr) {
            *error = L"Serial port is not open.";
        }
        return false;
    }

    Frame req;
    req.type = FrameType::Request;
    req.seq = seq;
    req.cmd = static_cast<std::uint8_t>(cmd);
    req.status = 0;
    req.payload = payload;

    const std::vector<std::uint8_t> raw = EncodeFrame(req);
    return port_->WriteAll(raw.data(), raw.size(), options_.command_timeout_ms, error);
}

std::vector<std::uint8_t> IspBridgeClient::MakeProgramBeginPayload(std::uint32_t image_size,
                                                                   std::uint32_t image_crc32,
                                                                   std::uint16_t block_size,
                                                                   std::uint8_t window) const {
    constexpr std::uint8_t kProgramBeginFlagDisableSecondRead = 0x01;
    constexpr std::uint8_t kProgramBeginFlagAckTraceWordData = 0x02;
    std::vector<std::uint8_t> payload;
    std::uint8_t flags = kProgramBeginFlagDisableSecondRead;
    if (options_.trace_can_tx_rx) {
        flags = static_cast<std::uint8_t>(flags | kProgramBeginFlagAckTraceWordData | kProgramBeginFlagPageDiag);
    }
    PutLe32(&payload, image_size);
    PutLe32(&payload, image_crc32);
    PutLe16(&payload, block_size);
    payload.push_back(window);
    payload.push_back(flags);
    return payload;
}

std::vector<std::uint8_t> IspBridgeClient::MakeProgramBlockPayload(std::uint32_t block_index,
                                                                   std::uint32_t offset,
                                                                   const std::uint8_t* block,
                                                                   std::uint16_t block_len) const {
    std::vector<std::uint8_t> payload;
    PutLe32(&payload, block_index);
    PutLe32(&payload, offset);
    PutLe16(&payload, block_len);
    payload.insert(payload.end(), block, block + block_len);
    return payload;
}

void IspBridgeClient::PutLe16(std::vector<std::uint8_t>* out, std::uint16_t v) {
    out->push_back(static_cast<std::uint8_t>(v & 0xFF));
    out->push_back(static_cast<std::uint8_t>((v >> 8) & 0xFF));
}

void IspBridgeClient::PutLe32(std::vector<std::uint8_t>* out, std::uint32_t v) {
    out->push_back(static_cast<std::uint8_t>(v & 0xFF));
    out->push_back(static_cast<std::uint8_t>((v >> 8) & 0xFF));
    out->push_back(static_cast<std::uint8_t>((v >> 16) & 0xFF));
    out->push_back(static_cast<std::uint8_t>((v >> 24) & 0xFF));
}

std::uint32_t IspBridgeClient::ReadLe32(const std::uint8_t* p) {
    return static_cast<std::uint32_t>(p[0]) |
           (static_cast<std::uint32_t>(p[1]) << 8) |
           (static_cast<std::uint32_t>(p[2]) << 16) |
           (static_cast<std::uint32_t>(p[3]) << 24);
}

std::uint32_t IspBridgeClient::Crc32(const std::uint8_t* data, std::size_t len) {
    std::uint32_t crc = 0xFFFFFFFFu;
    for (std::size_t i = 0; i < len; ++i) {
        crc ^= data[i];
        for (int b = 0; b < 8; ++b) {
            const std::uint32_t mask = static_cast<std::uint32_t>(-(static_cast<std::int32_t>(crc & 1u)));
            crc = (crc >> 1) ^ (0xEDB88320u & mask);
        }
    }
    return ~crc;
}

} // namespace serial_can::core


