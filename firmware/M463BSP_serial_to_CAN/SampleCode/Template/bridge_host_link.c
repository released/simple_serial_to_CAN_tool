#include <string.h>

#include "bridge_proto_def.h"
#include "bridge_host_link.h"
#include "bridge_hw_abstraction.h"

#define STREAM_BUF_SIZE                 (192u)

#define FRAME_HEADER_SIZE               (12u)
#define FRAME_TAIL_SIZE                 (2u)
#define FRAME_MIN_SIZE                  (14u)
#define FRAME_MAX_SIZE                  (FRAME_HEADER_SIZE + HOST_MAX_PAYLOAD + FRAME_TAIL_SIZE)

static uint8_t s_stream_buf[STREAM_BUF_SIZE];
static uint16_t s_stream_len;

static host_request_handler_t s_handler;
static uint8_t s_active_req_valid;
static host_request_t s_active_req;

typedef struct {
    uint8_t valid;
    uint16_t req_seq;
    uint8_t req_cmd;
    uint16_t req_payload_len;
    uint16_t req_payload_crc;
    uint16_t resp_len;
    uint8_t resp_bytes[FRAME_MAX_SIZE];
} response_cache_t;

static response_cache_t s_resp_cache;

static uint16_t rd_le16(const uint8_t *p)
{
    return (uint16_t)(p[0] | ((uint16_t)p[1] << 8));
}

static void wr_le16(uint8_t *p, uint16_t v)
{
    p[0] = (uint8_t)(v & 0xFFu);
    p[1] = (uint8_t)((v >> 8) & 0xFFu);
}

static uint16_t crc16_ccitt_false(const uint8_t *data, uint32_t len)
{
    uint32_t i;
    uint8_t bit;
    uint16_t crc = 0xFFFFu;

    for (i = 0; i < len; i++) {
        crc ^= (uint16_t)((uint16_t)data[i] << 8);
        for (bit = 0; bit < 8; bit++) {
            if (crc & 0x8000u) {
                crc = (uint16_t)((crc << 1) ^ 0x1021u);
            } else {
                crc <<= 1;
            }
        }
    }
    return crc;
}

static uint8_t request_matches_cached_response(const host_request_t *req)
{
    if ((s_resp_cache.valid == 0u) || (req == NULL)) {
        return 0u;
    }

    if ((req->seq != s_resp_cache.req_seq) ||
            (req->cmd != s_resp_cache.req_cmd) ||
            (req->payload_len != s_resp_cache.req_payload_len) ||
            (req->payload_crc != s_resp_cache.req_payload_crc)) {
        return 0u;
    }

    return 1u;
}

static uint8_t try_extract_request(host_request_t *out)
{
    uint16_t i;
    uint16_t payload_len;
    uint16_t total_len;
    uint16_t crc_rx;
    uint16_t crc_calc;

    while (s_stream_len >= 2u) {
        if ((s_stream_buf[0] == FRAME_SOF0) && (s_stream_buf[1] == FRAME_SOF1)) {
            break;
        }

        memmove(&s_stream_buf[0], &s_stream_buf[1], s_stream_len - 1u);
        s_stream_len--;
    }

    if (s_stream_len < FRAME_MIN_SIZE) {
        return 0u;
    }

    if ((s_stream_buf[2] != FRAME_VERSION) || (s_stream_buf[3] != FRAME_TYPE_REQUEST)) {
        memmove(&s_stream_buf[0], &s_stream_buf[1], s_stream_len - 1u);
        s_stream_len--;
        return 0u;
    }

    payload_len = rd_le16(&s_stream_buf[8]);
    if (payload_len > HOST_MAX_PAYLOAD) {
        memmove(&s_stream_buf[0], &s_stream_buf[1], s_stream_len - 1u);
        s_stream_len--;
        return 0u;
    }

    total_len = (uint16_t)(FRAME_HEADER_SIZE + payload_len + FRAME_TAIL_SIZE);
    if (s_stream_len < total_len) {
        return 0u;
    }

    crc_rx = rd_le16(&s_stream_buf[10]);
    crc_calc = crc16_ccitt_false(&s_stream_buf[2], 8u);
    if (crc_rx != crc_calc) {
        memmove(&s_stream_buf[0], &s_stream_buf[1], s_stream_len - 1u);
        s_stream_len--;
        return 0u;
    }

    crc_rx = rd_le16(&s_stream_buf[FRAME_HEADER_SIZE + payload_len]);
    crc_calc = crc16_ccitt_false((payload_len == 0u) ? (const uint8_t *)"" : &s_stream_buf[FRAME_HEADER_SIZE], payload_len);
    if (crc_rx != crc_calc) {
        memmove(&s_stream_buf[0], &s_stream_buf[1], s_stream_len - 1u);
        s_stream_len--;
        return 0u;
    }

    out->seq = rd_le16(&s_stream_buf[4]);
    out->cmd = s_stream_buf[6];
    out->payload_len = payload_len;
    out->payload_crc = rd_le16(&s_stream_buf[FRAME_HEADER_SIZE + payload_len]);

    if (payload_len > 0u) {
        memcpy(out->payload, &s_stream_buf[FRAME_HEADER_SIZE], payload_len);
    }

    for (i = total_len; i < s_stream_len; i++) {
        s_stream_buf[i - total_len] = s_stream_buf[i];
    }
    s_stream_len = (uint16_t)(s_stream_len - total_len);

    return 1u;
}

void host_link_init(host_request_handler_t handler)
{
    s_stream_len = 0u;
    s_handler = handler;
    s_active_req_valid = 0u;
    memset((void *)&s_active_req, 0, sizeof(s_active_req));
    memset((void *)&s_resp_cache, 0, sizeof(s_resp_cache));
}

void host_link_send_response(uint16_t seq,
                             uint8_t cmd,
                             uint8_t status,
                             const uint8_t *payload,
                             uint16_t payload_len)
{
    uint8_t frame[FRAME_MAX_SIZE];
    uint16_t total_len;
    uint16_t crc;

    if (payload_len > HOST_MAX_PAYLOAD) {
        payload_len = HOST_MAX_PAYLOAD;
    }

    frame[0] = FRAME_SOF0;
    frame[1] = FRAME_SOF1;
    frame[2] = FRAME_VERSION;
    frame[3] = FRAME_TYPE_RESPONSE;
    wr_le16(&frame[4], seq);
    frame[6] = cmd;
    frame[7] = status;
    wr_le16(&frame[8], payload_len);

    crc = crc16_ccitt_false(&frame[2], 8u);
    wr_le16(&frame[10], crc);

    if ((payload_len > 0u) && (payload != NULL)) {
        memcpy(&frame[12], payload, payload_len);
    }

    crc = crc16_ccitt_false((payload_len == 0u) ? (const uint8_t *)"" : &frame[12], payload_len);
    wr_le16(&frame[12 + payload_len], crc);

    total_len = (uint16_t)(12u + payload_len + 2u);

    if ((s_active_req_valid != 0u) &&
            (s_active_req.seq == seq) &&
            (s_active_req.cmd == cmd)) {
        s_resp_cache.valid = 1u;
        s_resp_cache.req_seq = s_active_req.seq;
        s_resp_cache.req_cmd = s_active_req.cmd;
        s_resp_cache.req_payload_len = s_active_req.payload_len;
        s_resp_cache.req_payload_crc = s_active_req.payload_crc;
        s_resp_cache.resp_len = total_len;
        memcpy(s_resp_cache.resp_bytes, frame, total_len);
    }

    bridge_hw_uart_send_bytes(frame, total_len);
}

void host_link_feed_bytes(const uint8_t *data, uint16_t len)
{
    uint16_t i;
    host_request_t req;

    for (i = 0u; i < len; i++) {
        if (s_stream_len < STREAM_BUF_SIZE) {
            s_stream_buf[s_stream_len++] = data[i];
        } else {
            memmove(&s_stream_buf[0], &s_stream_buf[1], STREAM_BUF_SIZE - 1u);
            s_stream_buf[STREAM_BUF_SIZE - 1u] = data[i];
        }
    }

    while (try_extract_request(&req)) {
        if (request_matches_cached_response(&req)) {
            bridge_hw_uart_send_bytes(s_resp_cache.resp_bytes, s_resp_cache.resp_len);
            continue;
        }

        if (s_handler != NULL) {
            s_active_req_valid = 1u;
            s_active_req = req;
            s_handler(&req);
            s_active_req_valid = 0u;
        }
    }
}

void host_link_poll_uart(void)
{
    uint8_t ch;

    while (bridge_hw_uart_try_pop_byte(&ch)) {
        host_link_feed_bytes(&ch, 1u);
    }
}
