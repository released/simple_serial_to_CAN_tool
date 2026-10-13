# 1 "../bridge_host_link.c"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 400 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "../bridge_host_link.c" 2
# 1 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 1 3
# 51 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
    typedef unsigned int size_t;






extern __attribute__((__nothrow__)) void *memcpy(void * __restrict ,
                    const void * __restrict , size_t ) __attribute__((__nonnull__(1,2)));






extern __attribute__((__nothrow__)) void *memmove(void * ,
                    const void * , size_t ) __attribute__((__nonnull__(1,2)));
# 77 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
extern __attribute__((__nothrow__)) char *strcpy(char * __restrict , const char * __restrict ) __attribute__((__nonnull__(1,2)));






extern __attribute__((__nothrow__)) char *strncpy(char * __restrict , const char * __restrict , size_t ) __attribute__((__nonnull__(1,2)));
# 93 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
extern __attribute__((__nothrow__)) char *strcat(char * __restrict , const char * __restrict ) __attribute__((__nonnull__(1,2)));






extern __attribute__((__nothrow__)) char *strncat(char * __restrict , const char * __restrict , size_t ) __attribute__((__nonnull__(1,2)));
# 117 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
extern __attribute__((__nothrow__)) int memcmp(const void * , const void * , size_t ) __attribute__((__nonnull__(1,2)));







extern __attribute__((__nothrow__)) int strcmp(const char * , const char * ) __attribute__((__nonnull__(1,2)));






extern __attribute__((__nothrow__)) int strncmp(const char * , const char * , size_t ) __attribute__((__nonnull__(1,2)));
# 141 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
extern __attribute__((__nothrow__)) int strcasecmp(const char * , const char * ) __attribute__((__nonnull__(1,2)));







extern __attribute__((__nothrow__)) int strncasecmp(const char * , const char * , size_t ) __attribute__((__nonnull__(1,2)));
# 158 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
extern __attribute__((__nothrow__)) int strcoll(const char * , const char * ) __attribute__((__nonnull__(1,2)));
# 169 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
extern __attribute__((__nothrow__)) size_t strxfrm(char * __restrict , const char * __restrict , size_t ) __attribute__((__nonnull__(2)));
# 193 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
extern __attribute__((__nothrow__)) void *memchr(const void * , int , size_t ) __attribute__((__nonnull__(1)));
# 209 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
extern __attribute__((__nothrow__)) char *strchr(const char * , int ) __attribute__((__nonnull__(1)));
# 218 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
extern __attribute__((__nothrow__)) size_t strcspn(const char * , const char * ) __attribute__((__nonnull__(1,2)));
# 232 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
extern __attribute__((__nothrow__)) char *strpbrk(const char * , const char * ) __attribute__((__nonnull__(1,2)));
# 247 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
extern __attribute__((__nothrow__)) char *strrchr(const char * , int ) __attribute__((__nonnull__(1)));
# 257 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
extern __attribute__((__nothrow__)) size_t strspn(const char * , const char * ) __attribute__((__nonnull__(1,2)));
# 270 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
extern __attribute__((__nothrow__)) char *strstr(const char * , const char * ) __attribute__((__nonnull__(1,2)));
# 280 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
extern __attribute__((__nothrow__)) char *strtok(char * __restrict , const char * __restrict ) __attribute__((__nonnull__(2)));
extern __attribute__((__nothrow__)) char *_strtok_r(char * , const char * , char ** ) __attribute__((__nonnull__(2,3)));
# 321 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
extern __attribute__((__nothrow__)) void *memset(void * , int , size_t ) __attribute__((__nonnull__(1)));





extern __attribute__((__nothrow__)) char *strerror(int );







extern __attribute__((__nothrow__)) size_t strlen(const char * ) __attribute__((__nonnull__(1)));





extern __attribute__((__nothrow__)) size_t strnlen(const char * , size_t ) __attribute__((__nonnull__(1)));







extern __attribute__((__nothrow__)) size_t strlcpy(char * , const char * , size_t ) __attribute__((__nonnull__(1,2)));
# 369 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
extern __attribute__((__nothrow__)) size_t strlcat(char * , const char * , size_t ) __attribute__((__nonnull__(1,2)));
# 395 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
extern __attribute__((__nothrow__)) void _membitcpybl(void * , const void * , int , int , size_t ) __attribute__((__nonnull__(1,2)));
extern __attribute__((__nothrow__)) void _membitcpybb(void * , const void * , int , int , size_t ) __attribute__((__nonnull__(1,2)));
extern __attribute__((__nothrow__)) void _membitcpyhl(void * , const void * , int , int , size_t ) __attribute__((__nonnull__(1,2)));
extern __attribute__((__nothrow__)) void _membitcpyhb(void * , const void * , int , int , size_t ) __attribute__((__nonnull__(1,2)));
extern __attribute__((__nothrow__)) void _membitcpywl(void * , const void * , int , int , size_t ) __attribute__((__nonnull__(1,2)));
extern __attribute__((__nothrow__)) void _membitcpywb(void * , const void * , int , int , size_t ) __attribute__((__nonnull__(1,2)));
extern __attribute__((__nothrow__)) void _membitmovebl(void * , const void * , int , int , size_t ) __attribute__((__nonnull__(1,2)));
extern __attribute__((__nothrow__)) void _membitmovebb(void * , const void * , int , int , size_t ) __attribute__((__nonnull__(1,2)));
extern __attribute__((__nothrow__)) void _membitmovehl(void * , const void * , int , int , size_t ) __attribute__((__nonnull__(1,2)));
extern __attribute__((__nothrow__)) void _membitmovehb(void * , const void * , int , int , size_t ) __attribute__((__nonnull__(1,2)));
extern __attribute__((__nothrow__)) void _membitmovewl(void * , const void * , int , int , size_t ) __attribute__((__nonnull__(1,2)));
extern __attribute__((__nothrow__)) void _membitmovewb(void * , const void * , int , int , size_t ) __attribute__((__nonnull__(1,2)));
# 2 "../bridge_host_link.c" 2

# 1 "..\\bridge_proto_def.h" 1



# 1 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdint.h" 1 3
# 56 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdint.h" 3
typedef signed char int8_t;
typedef signed short int int16_t;
typedef signed int int32_t;
typedef signed long long int int64_t;


typedef unsigned char uint8_t;
typedef unsigned short int uint16_t;
typedef unsigned int uint32_t;
typedef unsigned long long int uint64_t;





typedef signed char int_least8_t;
typedef signed short int int_least16_t;
typedef signed int int_least32_t;
typedef signed long long int int_least64_t;


typedef unsigned char uint_least8_t;
typedef unsigned short int uint_least16_t;
typedef unsigned int uint_least32_t;
typedef unsigned long long int uint_least64_t;




typedef signed int int_fast8_t;
typedef signed int int_fast16_t;
typedef signed int int_fast32_t;
typedef signed long long int int_fast64_t;


typedef unsigned int uint_fast8_t;
typedef unsigned int uint_fast16_t;
typedef unsigned int uint_fast32_t;
typedef unsigned long long int uint_fast64_t;






typedef signed int intptr_t;
typedef unsigned int uintptr_t;



typedef signed long long intmax_t;
typedef unsigned long long uintmax_t;
# 5 "..\\bridge_proto_def.h" 2
# 4 "../bridge_host_link.c" 2
# 1 "..\\bridge_host_link.h" 1







typedef struct {
    uint16_t seq;
    uint8_t cmd;
    uint16_t payload_len;
    uint16_t payload_crc;
    uint8_t payload[(96u)];
} host_request_t;

typedef void (*host_request_handler_t)(const host_request_t *req);

void host_link_init(host_request_handler_t handler);
void host_link_poll_uart(void);
void host_link_feed_bytes(const uint8_t *data, uint16_t len);
void host_link_send_response(uint16_t seq,
                             uint8_t cmd,
                             uint8_t status,
                             const uint8_t *payload,
                             uint16_t payload_len);
# 5 "../bridge_host_link.c" 2
# 1 "..\\bridge_hw_abstraction.h" 1





typedef void (*bridge_can_backend_rx_push_fn)(uint32_t cmd, uint32_t data);

void bridge_hw_board_init(void);
void bridge_hw_uart_init(void);
void bridge_hw_can_init(uint32_t bitrate);
uint32_t bridge_hw_can_get_bitrate(void);
void bridge_hw_can_set_rx_filter(uint16_t std_id);
void bridge_hw_can_stop(void);
uint8_t bridge_hw_can_tx_cleanup_slot(uint8_t tx_slot);
void bridge_hw_system_reset(void);

void bridge_hw_uart_send_bytes(const uint8_t *data, uint16_t len);
void bridge_hw_uart_wait_tx_empty(void);
uint8_t bridge_hw_uart_wait_tx_empty_timeout(uint32_t timeout_ms);
uint8_t bridge_hw_uart_try_pop_byte(uint8_t *out);

uint8_t bridge_hw_can_send_cmd_data(uint16_t std_id, uint32_t cmd, uint32_t data);
uint8_t bridge_hw_can_send_cmd_data_slot(uint8_t tx_slot, uint16_t std_id, uint32_t cmd, uint32_t data);
uint8_t bridge_hw_can_try_read_cmd_data(uint32_t *cmd, uint32_t *data);
# 6 "../bridge_host_link.c" 2








static uint8_t s_stream_buf[(192u)];
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
    uint8_t resp_bytes[((12u) + (96u) + (2u))];
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
    if ((s_resp_cache.valid == 0u) || (req == 0)) {
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
        if ((s_stream_buf[0] == (0x55u)) && (s_stream_buf[1] == (0xAAu))) {
            break;
        }

        memmove(&s_stream_buf[0], &s_stream_buf[1], s_stream_len - 1u);
        s_stream_len--;
    }

    if (s_stream_len < (14u)) {
        return 0u;
    }

    if ((s_stream_buf[2] != (0x01u)) || (s_stream_buf[3] != (0x10u))) {
        memmove(&s_stream_buf[0], &s_stream_buf[1], s_stream_len - 1u);
        s_stream_len--;
        return 0u;
    }

    payload_len = rd_le16(&s_stream_buf[8]);
    if (payload_len > (96u)) {
        memmove(&s_stream_buf[0], &s_stream_buf[1], s_stream_len - 1u);
        s_stream_len--;
        return 0u;
    }

    total_len = (uint16_t)((12u) + payload_len + (2u));
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

    crc_rx = rd_le16(&s_stream_buf[(12u) + payload_len]);
    crc_calc = crc16_ccitt_false((payload_len == 0u) ? (const uint8_t *)"" : &s_stream_buf[(12u)], payload_len);
    if (crc_rx != crc_calc) {
        memmove(&s_stream_buf[0], &s_stream_buf[1], s_stream_len - 1u);
        s_stream_len--;
        return 0u;
    }

    out->seq = rd_le16(&s_stream_buf[4]);
    out->cmd = s_stream_buf[6];
    out->payload_len = payload_len;
    out->payload_crc = rd_le16(&s_stream_buf[(12u) + payload_len]);

    if (payload_len > 0u) {
        memcpy(out->payload, &s_stream_buf[(12u)], payload_len);
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
    uint8_t frame[((12u) + (96u) + (2u))];
    uint16_t total_len;
    uint16_t crc;

    if (payload_len > (96u)) {
        payload_len = (96u);
    }

    frame[0] = (0x55u);
    frame[1] = (0xAAu);
    frame[2] = (0x01u);
    frame[3] = (0x20u);
    wr_le16(&frame[4], seq);
    frame[6] = cmd;
    frame[7] = status;
    wr_le16(&frame[8], payload_len);

    crc = crc16_ccitt_false(&frame[2], 8u);
    wr_le16(&frame[10], crc);

    if ((payload_len > 0u) && (payload != 0)) {
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
        if (s_stream_len < (192u)) {
            s_stream_buf[s_stream_len++] = data[i];
        } else {
            memmove(&s_stream_buf[0], &s_stream_buf[1], (192u) - 1u);
            s_stream_buf[(192u) - 1u] = data[i];
        }
    }

    while (try_extract_request(&req)) {
        if (request_matches_cached_response(&req)) {
            bridge_hw_uart_send_bytes(s_resp_cache.resp_bytes, s_resp_cache.resp_len);
            continue;
        }

        if (s_handler != 0) {
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
