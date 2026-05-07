#include <string.h>
#include <stdint.h>

#include "bridge_proto_def.h"
#include "bridge_board_config.h"
#include "bridge_host_link.h"
#include "bridge_nuvoisp_can.h"
#include "bridge_hw_abstraction.h"

#define CAN_ID_BRIDGE_TO_TARGET         (0x487u)
#define CAN_ID_TARGET_TO_BRIDGE         (0x784u)

#define CAN_CMD_ERASE_ALL               (0xA3000000u)
#define CAN_CMD_RUN_APROM               (0xAB000000u)
#define CAN_CMD_GET_DEVICEID            (0xB1000000u)
#define CAN_CMD_READ_CONFIG             (0xA2000000u)

#define ISP_CMD_GET_VERSION             (0xA6000000u)
#define ISP_CMD_CONNECT                 (0xAE000000u)
#define ISP_CMD_SYNC_PACKNO             (0xA4000000u)
#define ISP_CMD_GET_DEVICEID            (0xB1000000u)
#define ISP_CMD_ERASE_ALL               (0xA3000000u)
#define ISP_CMD_RUN_APROM               (0xAB000000u)
#define ISP_CMD_RUN_LDROM               (0xAC000000u)
#define ISP_CMD_RESET                   (0xAD000000u)
#define ISP_CMD_RESEND_PACKET           (0xFF000000u)
#define ISP_CMD_ERASE_SPIFLASH          (0xD0000000u)
#define ISP_CMD_UPDATE_SPIFLASH         (0xD1000000u)
#define ISP_CMD_UPDATE_CONFIG           (0xA1000000u)
#define ISP_CMD_READ_CONFIG             (0xA2000000u)
#define ISP_CMD_READ_CONFIG_EXT         (0xE0000000u)
#define ISP_CMD_UPDATE_CONFIG_EXT       (0xE1000000u)

/* EVB->target CAN policy:
 * - keep retry=1 (single attempt, no internal resend).
 * - use moderate timeout to avoid excessive per-word wait.
 */
#define CAN_CMD_TIMEOUT_MS              (5000u)
#define CAN_ERASE_TIMEOUT_MS            (10000u)
#define CAN_ACK_TIMEOUT_MS              (800u)
#define CAN_MAX_RETRY                   (1u)

#define ISP_RAW_FLAG_NO_ACK             (0x01u)

#define PROGRAM_QUEUE_DEPTH             (4u)
#define PROGRAM_BLOCK_MAX               (80u)
#define ACK_HISTORY_DEPTH               (4u)
#define PAGE_BOUNDARY_GUARD_WORDS       (4u)
#define PAGE_DIAG_RECORD_COUNT          (8u)

#ifndef BRIDGE_ACK_STRICT_COMPARE
#define BRIDGE_ACK_STRICT_COMPARE       (1u)
#endif

#ifndef BRIDGE_DIAG_MINIMAL_ENABLE
#define BRIDGE_DIAG_MINIMAL_ENABLE      (0u)
#endif

#ifndef BRIDGE_CAN_TX_GAP_DIAG_MS
#define BRIDGE_CAN_TX_GAP_DIAG_MS       (0u)
#endif

#ifndef BRIDGE_CAN_TX_SLOT_COUNT
#define BRIDGE_CAN_TX_SLOT_COUNT        (1u)
#endif

#ifndef BRIDGE_TARGET_PAGE_BOUNDARY_DELAY_ENABLE
#define BRIDGE_TARGET_PAGE_BOUNDARY_DELAY_ENABLE    (0u)
#endif

#ifndef BRIDGE_TARGET_PAGE_BOUNDARY_BYTES
#define BRIDGE_TARGET_PAGE_BOUNDARY_BYTES           (512u)
#endif

#ifndef BRIDGE_TARGET_PAGE_BOUNDARY_DELAY_MS
#define BRIDGE_TARGET_PAGE_BOUNDARY_DELAY_MS        (30u)
#endif

#ifndef BRIDGE_TARGET_PAGE_ERASE_DIAG_ENABLE
#define BRIDGE_TARGET_PAGE_ERASE_DIAG_ENABLE        (0u)
#endif

#ifndef BRIDGE_TARGET_PAGE_SIZE_DIAG_BYTES
#define BRIDGE_TARGET_PAGE_SIZE_DIAG_BYTES          (2048u)
#endif

#ifndef BRIDGE_TARGET_PAGE_ERASE_GUARD_BYTES
#define BRIDGE_TARGET_PAGE_ERASE_GUARD_BYTES        (64u)
#endif

#ifndef BRIDGE_TARGET_PAGE_ERASE_ACK_TIMEOUT_MS
#define BRIDGE_TARGET_PAGE_ERASE_ACK_TIMEOUT_MS     (15000u)
#endif

/* Match NuLink2-Pro target-side log pattern:
 * send several READ_CONFIG frames before first APROM word programming.
 */
#define PROGRAM_BEGIN_READCFG_WARMUP_COUNT          (14u)
#define PROGRAM_BEGIN_FLAG_DISABLE_SECOND_READ      (0x01u)
#define PROGRAM_BEGIN_FLAG_ACK_TRACE_WORD_DATA      (0x02u)
#define PROGRAM_BEGIN_FLAG_PAGE_DIAG                (0x04u)

typedef struct {
    uint8_t valid;
    uint16_t addr16;
    uint32_t tx_word;
    uint32_t ack_word;
    uint8_t tx_count;
    uint8_t ack_count;
} page_diag_record_t;

typedef struct {
    uint8_t used;
    uint16_t seq;
    uint32_t block_index;
    uint32_t offset;
    uint16_t len;
    uint8_t data[PROGRAM_BLOCK_MAX];
} program_block_item_t;

typedef struct {
    uint8_t valid;
    uint16_t seq;
    uint32_t block_index;
} ack_record_t;

typedef struct {
    uint8_t active;
    uint8_t ack_trace_word_data;
    uint8_t page_diag_enable;
    uint32_t image_size;
    uint32_t image_crc32;
    uint16_t block_size;
    uint8_t window;
    uint32_t expected_block_index;
    uint32_t programmed_size;
    uint32_t crc32_running;
    uint32_t page_boundary_seen[PAGE_BOUNDARY_GUARD_WORDS];
    page_diag_record_t page_diag[PAGE_DIAG_RECORD_COUNT];
    uint8_t page_diag_ring_next;
} program_ctx_t;

static volatile uint32_t s_ms_ticks = 0u;
static uint32_t s_can_bitrate = BRIDGE_CAN_DEFAULT_BITRATE;
static uint32_t s_last_can_tx_ms = 0u;
static uint8_t s_last_can_tx_valid = 0u;
static uint8_t s_next_can_tx_slot = 0u;
static uint8_t s_last_can_tx_slot = 0u;
static uint32_t s_last_can_tx_cmd = 0u;
static uint32_t s_last_can_tx_data = 0u;

static program_block_item_t s_prog_queue[PROGRAM_QUEUE_DEPTH];
static uint8_t s_prog_q_head = 0u;
static uint8_t s_prog_q_tail = 0u;
static uint8_t s_prog_q_count = 0u;
static uint8_t s_prog_exec_valid = 0u;
static uint16_t s_prog_exec_seq = 0u;
static uint32_t s_prog_exec_block_index = 0u;

static ack_record_t s_ack_history[ACK_HISTORY_DEPTH];
static uint8_t s_ack_history_pos = 0u;

static program_ctx_t s_prog_ctx;
static uint8_t s_run_aprom_sent = 0u;
static uint8_t s_bootloader_online = 0u;
static uint32_t s_bootloader_device_id = 0u;
static uint8_t s_readcfg_warmup_done = 0u;

static void send_status_only(uint16_t seq, uint8_t cmd, uint8_t status);

typedef enum {
    DIAG_REASON_NONE = 0u,
    DIAG_REASON_TX_FAIL = 1u,
    DIAG_REASON_ACK_TIMEOUT = 2u,
    DIAG_REASON_ACK_MISMATCH = 3u,
    DIAG_REASON_PAGE_REPEAT = 4u,
    DIAG_REASON_TX_CLEANUP_FAIL = 5u
} diag_reason_t;

typedef enum {
    CONNECT_DIAG_PHASE_NONE = 0u,
    CONNECT_DIAG_PHASE_B1 = 1u,
    CONNECT_DIAG_PHASE_A2 = 2u
} connect_diag_phase_t;

static uint32_t rd_le32(const uint8_t *p)
{
    return ((uint32_t)p[0]) |
           ((uint32_t)p[1] << 8) |
           ((uint32_t)p[2] << 16) |
           ((uint32_t)p[3] << 24);
}

static uint16_t rd_le16(const uint8_t *p)
{
    return (uint16_t)(p[0] | ((uint16_t)p[1] << 8));
}

static void wr_le16(uint8_t *p, uint16_t v)
{
    p[0] = (uint8_t)(v & 0xFFu);
    p[1] = (uint8_t)((v >> 8) & 0xFFu);
}

static void wr_le32(uint8_t *p, uint32_t v)
{
    p[0] = (uint8_t)(v & 0xFFu);
    p[1] = (uint8_t)((v >> 8) & 0xFFu);
    p[2] = (uint8_t)((v >> 16) & 0xFFu);
    p[3] = (uint8_t)((v >> 24) & 0xFFu);
}

static uint32_t crc32_update(uint32_t crc, const uint8_t *data, uint32_t len)
{
    uint32_t i;
    uint8_t bit;

    for (i = 0u; i < len; i++) {
        crc ^= data[i];
        for (bit = 0u; bit < 8u; bit++) {
            if (crc & 1u) {
                crc = (crc >> 1) ^ 0xEDB88320u;
            } else {
                crc >>= 1;
            }
        }
    }
    return crc;
}

static uint32_t millis(void)
{
    return s_ms_ticks;
}

static uint8_t timeout_expired(uint32_t start, uint32_t timeout_ms)
{
    return ((uint32_t)(millis() - start) >= timeout_ms) ? 1u : 0u;
}

static void can_init(uint32_t bitrate)
{
    bridge_hw_can_set_rx_filter((uint16_t)CAN_ID_TARGET_TO_BRIDGE);
    bridge_hw_can_init(bitrate);
    s_can_bitrate = bridge_hw_can_get_bitrate();
    s_last_can_tx_valid = 0u;
    s_next_can_tx_slot = 0u;
    s_last_can_tx_slot = 0u;
    s_last_can_tx_cmd = 0u;
    s_last_can_tx_data = 0u;
}

static void can_wait_tx_gap_diag(void)
{
#if (BRIDGE_CAN_TX_GAP_DIAG_MS != 0u)
    if (s_last_can_tx_valid != 0u) {
        while (!timeout_expired(s_last_can_tx_ms, BRIDGE_CAN_TX_GAP_DIAG_MS)) {
        }
    }
#endif
}

static uint8_t can_send_word(uint32_t cmd, uint32_t data)
{
    uint8_t ok;
    uint8_t tx_slot = s_next_can_tx_slot;

    can_wait_tx_gap_diag();
    ok = bridge_hw_can_send_cmd_data_slot(tx_slot, (uint16_t)CAN_ID_BRIDGE_TO_TARGET, cmd, data);
    if (ok != 0u) {
        s_last_can_tx_ms = millis();
        s_last_can_tx_valid = 1u;
        s_last_can_tx_slot = tx_slot;
        s_last_can_tx_cmd = cmd;
        s_last_can_tx_data = data;
#if (BRIDGE_CAN_TX_SLOT_COUNT > 1u)
        s_next_can_tx_slot = (uint8_t)((tx_slot + 1u) % BRIDGE_CAN_TX_SLOT_COUNT);
#else
        s_next_can_tx_slot = 0u;
#endif
    }
    return ok;
}

static uint8_t is_page_boundary_addr(uint32_t addr)
{
#if (BRIDGE_TARGET_PAGE_BOUNDARY_BYTES != 0u)
    return ((addr % BRIDGE_TARGET_PAGE_BOUNDARY_BYTES) == 0u) ? 1u : 0u;
#else
    (void)addr;
    return 0u;
#endif
}

static void program_page_boundary_guard_reset(void)
{
    uint32_t i;

    for (i = 0u; i < PAGE_BOUNDARY_GUARD_WORDS; i++) {
        s_prog_ctx.page_boundary_seen[i] = 0xFFFFFFFFu;
    }
}

static void program_page_diag_reset(void)
{
    uint32_t i;

    for (i = 0u; i < PAGE_DIAG_RECORD_COUNT; i++) {
        memset(&s_prog_ctx.page_diag[i], 0, sizeof(s_prog_ctx.page_diag[i]));
    }
    s_prog_ctx.page_diag_ring_next = 1u;
}

static page_diag_record_t *program_page_diag_find_or_alloc(uint32_t addr, uint32_t word)
{
    uint32_t i;
    page_diag_record_t *rec = NULL;

    if (is_page_boundary_addr(addr) == 0u) {
        return NULL;
    }

    for (i = 0u; i < PAGE_DIAG_RECORD_COUNT; i++) {
        if ((s_prog_ctx.page_diag[i].valid != 0u) &&
            (s_prog_ctx.page_diag[i].addr16 == (uint16_t)addr)) {
            return &s_prog_ctx.page_diag[i];
        }
    }

    if (addr == 0u) {
        rec = &s_prog_ctx.page_diag[0];
    } else {
        if (word == 0xFFFFFFFFu) {
            return NULL;
        }
        rec = &s_prog_ctx.page_diag[s_prog_ctx.page_diag_ring_next];
        s_prog_ctx.page_diag_ring_next++;
        if (s_prog_ctx.page_diag_ring_next >= PAGE_DIAG_RECORD_COUNT) {
            s_prog_ctx.page_diag_ring_next = 1u;
        }
    }

    memset(rec, 0, sizeof(*rec));
    rec->valid = 1u;
    rec->addr16 = (uint16_t)addr;
    rec->ack_word = 0xFFFFFFFFu;
    return rec;
}

static void program_page_diag_note_tx(uint32_t addr, uint32_t word)
{
    page_diag_record_t *rec = program_page_diag_find_or_alloc(addr, word);
    if (rec == NULL) {
        return;
    }

    rec->tx_word = word;
    if (rec->tx_count != 0xFFu) {
        rec->tx_count++;
    }
}

static void program_page_diag_note_ack(uint32_t addr, uint32_t ack_word)
{
    uint32_t i;

    for (i = 0u; i < PAGE_DIAG_RECORD_COUNT; i++) {
        if ((s_prog_ctx.page_diag[i].valid != 0u) &&
            (s_prog_ctx.page_diag[i].addr16 == (uint16_t)addr)) {
            s_prog_ctx.page_diag[i].ack_word = ack_word;
            if (s_prog_ctx.page_diag[i].ack_count != 0xFFu) {
                s_prog_ctx.page_diag[i].ack_count++;
            }
            return;
        }
    }
}

static uint16_t build_program_end_diag_payload(uint8_t *payload, uint16_t payload_capacity)
{
    uint32_t i;
    uint8_t count = 0u;
    uint16_t pos = 1u;

    if ((payload == NULL) || (payload_capacity < 1u)) {
        return 0u;
    }

    payload[0] = 0u;
    for (i = 0u; i < PAGE_DIAG_RECORD_COUNT; i++) {
        const page_diag_record_t *rec = &s_prog_ctx.page_diag[i];
        if (rec->valid == 0u) {
            continue;
        }
        if ((uint16_t)(pos + 11u) > payload_capacity) {
            break;
        }

        wr_le16(&payload[pos], rec->addr16);
        wr_le32(&payload[pos + 2u], rec->tx_word);
        wr_le32(&payload[pos + 6u], rec->ack_word);
        payload[pos + 10u] = (uint8_t)(((rec->ack_count & 0x0Fu) << 4) | (rec->tx_count & 0x0Fu));
        pos = (uint16_t)(pos + 11u);
        count++;
    }

    payload[0] = count;
    return pos;
}

static uint8_t program_page_boundary_guard_mark(uint32_t addr)
{
    uint32_t i;

    if (is_page_boundary_addr(addr) == 0u) {
        return 1u;
    }

    for (i = 0u; i < PAGE_BOUNDARY_GUARD_WORDS; i++) {
        if (s_prog_ctx.page_boundary_seen[i] == addr) {
            return 0u;
        }
    }

    for (i = 0u; i < PAGE_BOUNDARY_GUARD_WORDS; i++) {
        if (s_prog_ctx.page_boundary_seen[i] == 0xFFFFFFFFu) {
            s_prog_ctx.page_boundary_seen[i] = addr;
            return 1u;
        }
    }

    s_prog_ctx.page_boundary_seen[0] = addr;
    return 1u;
}

static void program_wait_page_boundary_pre_tx_delay(uint32_t addr)
{
#if (BRIDGE_TARGET_PAGE_BOUNDARY_DELAY_ENABLE != 0u)
    if ((BRIDGE_TARGET_PAGE_BOUNDARY_BYTES != 0u) &&
        ((addr % BRIDGE_TARGET_PAGE_BOUNDARY_BYTES) == 0u)) {
        uint32_t start = millis();
        while (!timeout_expired(start, BRIDGE_TARGET_PAGE_BOUNDARY_DELAY_MS)) {
        }
    }
#else
    (void)addr;
#endif
}

static void program_wait_page_boundary_delay(uint32_t addr)
{
#if (BRIDGE_TARGET_PAGE_BOUNDARY_DELAY_ENABLE != 0u)
    if ((BRIDGE_TARGET_PAGE_BOUNDARY_BYTES != 0u) &&
        ((addr % BRIDGE_TARGET_PAGE_BOUNDARY_BYTES) == 0u)) {
        uint32_t start = millis();
        while (!timeout_expired(start, BRIDGE_TARGET_PAGE_BOUNDARY_DELAY_MS)) {
        }
    }
#else
    (void)addr;
#endif
}

static void send_ok_then_reset(uint16_t seq, uint8_t cmd)
{
    uint8_t tx_empty = 0u;
    /* RUN_APROM does not expect a target ACK. Stop CAN immediately after
     * forwarding AB so the bridge cannot leak a stale/repeated RUN frame
     * while UART is still flushing the host-side OK response.
     */
    bridge_hw_can_stop();
    send_status_only(seq, cmd, STATUS_OK);
    tx_empty = bridge_hw_uart_wait_tx_empty_timeout(BRIDGE_RUN_UART_FLUSH_TIMEOUT_MS);
    (void)tx_empty;
    bridge_hw_system_reset();
    while (1) {
    }
}

static void can_drop_stale_rx(void)
{
    uint32_t rx_cmd;
    uint32_t rx_data;

    while (bridge_hw_can_try_read_cmd_data(&rx_cmd, &rx_data)) {
        (void)rx_cmd;
        (void)rx_data;
    }
}

static uint8_t can_wait_ack(uint32_t expect_cmd, uint32_t *out_data, uint32_t timeout_ms)
{
    uint32_t start = millis();

    while (!timeout_expired(start, timeout_ms)) {
        uint32_t rx_cmd = 0u;
        uint32_t rx_data = 0u;
        if (bridge_hw_can_try_read_cmd_data(&rx_cmd, &rx_data)) {
            if (rx_cmd == expect_cmd) {
                if (out_data != NULL) {
                    *out_data = rx_data;
                }
                return 1u;
            }
        }
    }

    return 0u;
}

static uint8_t can_wait_ack_blocking(uint32_t expect_cmd,
                                     uint32_t *out_data,
                                     uint32_t timeout_ms,
                                     uint32_t *out_last_rx_cmd,
                                     uint32_t *out_last_rx_data)
{
    uint32_t start = millis();

    for (;;) {
        uint32_t rx_cmd = 0u;
        uint32_t rx_data = 0u;

        if (timeout_expired(start, timeout_ms)) {
            return 0u;
        }

        if (bridge_hw_can_try_read_cmd_data(&rx_cmd, &rx_data)) {
            if (rx_cmd == expect_cmd) {
                if (out_data != NULL) {
                    *out_data = rx_data;
                }
                return 1u;
            }
            if (out_last_rx_cmd != NULL) {
                *out_last_rx_cmd = rx_cmd;
            }
            if (out_last_rx_data != NULL) {
                *out_last_rx_data = rx_data;
            }
        }
    }
}

static uint32_t program_word_ack_timeout_ms(uint32_t addr)
{
#if (BRIDGE_TARGET_PAGE_ERASE_DIAG_ENABLE != 0u)
    if ((BRIDGE_TARGET_PAGE_SIZE_DIAG_BYTES != 0u) &&
        ((addr % BRIDGE_TARGET_PAGE_SIZE_DIAG_BYTES) < BRIDGE_TARGET_PAGE_ERASE_GUARD_BYTES)) {
        return BRIDGE_TARGET_PAGE_ERASE_ACK_TIMEOUT_MS;
    }
#else
    (void)addr;
#endif
    return CAN_CMD_TIMEOUT_MS;
}

static uint8_t can_exec_with_retry(uint32_t cmd,
                                   uint32_t data,
                                   uint32_t timeout_ms,
                                   uint32_t retry_count,
                                   uint32_t *out_data)
{
    uint32_t i;

    /* Flush old replies before starting a new host transaction.
     * Do not clear RX in low-level TX path, otherwise a fresh ACK can be lost.
     */
    can_drop_stale_rx();

    for (i = 0u; i < retry_count; i++) {
        if (!can_send_word(cmd, data)) {
            continue;
        }
        if (can_wait_ack(cmd, out_data, timeout_ms)) {
            return 1u;
        }
    }

    return 0u;
}

static uint8_t can_exec_with_retry_diag(uint32_t cmd,
                                        uint32_t data,
                                        uint32_t timeout_ms,
                                        uint32_t retry_count,
                                        uint32_t *out_data,
                                        uint32_t *out_last_rx_cmd,
                                        uint32_t *out_last_rx_data)
{
    uint32_t i;

    if (out_last_rx_cmd != NULL) {
        *out_last_rx_cmd = 0u;
    }
    if (out_last_rx_data != NULL) {
        *out_last_rx_data = 0u;
    }

    can_drop_stale_rx();

    for (i = 0u; i < retry_count; i++) {
        uint32_t last_rx_cmd = 0u;
        uint32_t last_rx_data = 0u;

        if (!can_send_word(cmd, data)) {
            continue;
        }
        if (can_wait_ack_blocking(cmd, out_data, timeout_ms, &last_rx_cmd, &last_rx_data)) {
            return 1u;
        }
        if (out_last_rx_cmd != NULL) {
            *out_last_rx_cmd = last_rx_cmd;
        }
        if (out_last_rx_data != NULL) {
            *out_last_rx_data = last_rx_data;
        }
    }

    return 0u;
}

static uint8_t send_run_aprom_once(void)
{
    if (s_run_aprom_sent != 0u) {
        return 1u;
    }

    if (!can_send_word(CAN_CMD_RUN_APROM, 0u)) {
        return 0u;
    }

    s_run_aprom_sent = 1u;
    return 1u;
}

static uint8_t perform_readcfg_warmup(void)
{
    uint32_t warmup_ack = 0u;
    uint32_t i;

    if (s_readcfg_warmup_done != 0u) {
        return 1u;
    }

    for (i = 0u; i < PROGRAM_BEGIN_READCFG_WARMUP_COUNT; i++) {
        if (!can_exec_with_retry(CAN_CMD_READ_CONFIG,
                                 i * 4u,
                                 CAN_CMD_TIMEOUT_MS,
                                 CAN_MAX_RETRY,
                                 &warmup_ack)) {
            return 0u;
        }
    }

    s_readcfg_warmup_done = 1u;
    return 1u;
}

static void perform_readcfg_warmup_best_effort(void)
{
    if (!perform_readcfg_warmup()) {
        s_readcfg_warmup_done = 0u;
    }
}

static void program_queue_reset(void)
{
    uint8_t i;
    s_prog_q_head = 0u;
    s_prog_q_tail = 0u;
    s_prog_q_count = 0u;
    s_prog_exec_valid = 0u;
    s_prog_exec_seq = 0u;
    s_prog_exec_block_index = 0u;
    for (i = 0u; i < PROGRAM_QUEUE_DEPTH; i++) {
        s_prog_queue[i].used = 0u;
    }
}

static uint8_t program_queue_find(uint32_t block_index, uint16_t seq)
{
    uint8_t i;
    for (i = 0u; i < PROGRAM_QUEUE_DEPTH; i++) {
        if ((s_prog_queue[i].used != 0u) &&
                (s_prog_queue[i].block_index == block_index) &&
                (s_prog_queue[i].seq == seq)) {
            return 1u;
        }
    }
    return 0u;
}

static uint8_t program_queue_push(uint16_t seq,
                                  uint32_t block_index,
                                  uint32_t offset,
                                  const uint8_t *data,
                                  uint16_t len)
{
    program_block_item_t *item;

    if ((s_prog_q_count >= PROGRAM_QUEUE_DEPTH) || (len > PROGRAM_BLOCK_MAX)) {
        return 0u;
    }

    item = &s_prog_queue[s_prog_q_tail];
    item->used = 1u;
    item->seq = seq;
    item->block_index = block_index;
    item->offset = offset;
    item->len = len;
    memcpy(item->data, data, len);

    s_prog_q_tail = (uint8_t)((s_prog_q_tail + 1u) % PROGRAM_QUEUE_DEPTH);
    s_prog_q_count++;
    return 1u;
}

static uint8_t program_queue_pop(program_block_item_t *out)
{
    program_block_item_t *item;

    if (s_prog_q_count == 0u) {
        return 0u;
    }

    item = &s_prog_queue[s_prog_q_head];
    if (out != NULL) {
        *out = *item;
    }

    item->used = 0u;
    s_prog_q_head = (uint8_t)((s_prog_q_head + 1u) % PROGRAM_QUEUE_DEPTH);
    s_prog_q_count--;
    return 1u;
}

static void ack_history_reset(void)
{
    uint8_t i;
    s_ack_history_pos = 0u;
    for (i = 0u; i < ACK_HISTORY_DEPTH; i++) {
        s_ack_history[i].valid = 0u;
    }
}

static void ack_history_put(uint32_t block_index, uint16_t seq)
{
    s_ack_history[s_ack_history_pos].valid = 1u;
    s_ack_history[s_ack_history_pos].block_index = block_index;
    s_ack_history[s_ack_history_pos].seq = seq;
    s_ack_history_pos = (uint8_t)((s_ack_history_pos + 1u) % ACK_HISTORY_DEPTH);
}

static uint8_t ack_history_match(uint32_t block_index, uint16_t seq)
{
    uint8_t i;
    for (i = 0u; i < ACK_HISTORY_DEPTH; i++) {
        if ((s_ack_history[i].valid != 0u) &&
                (s_ack_history[i].block_index == block_index) &&
                (s_ack_history[i].seq == seq)) {
            return 1u;
        }
    }
    return 0u;
}

static void send_status_only(uint16_t seq, uint8_t cmd, uint8_t status)
{
    host_link_send_response(seq, cmd, status, NULL, 0u);
}

static void send_program_block_fail(uint16_t seq,
                                    uint8_t status,
                                    uint32_t addr,
                                    uint32_t expected,
                                    uint32_t observed,
                                    uint32_t last_rx_cmd,
                                    uint32_t last_rx_data,
                                    uint8_t reason)
{
#if (BRIDGE_DIAG_MINIMAL_ENABLE != 0u)
    uint8_t detail[25];
    (void)last_rx_data;
    wr_le32(&detail[0], addr);
    wr_le32(&detail[4], expected);
    wr_le32(&detail[8], observed);
    detail[12] = reason;
    wr_le32(&detail[13], last_rx_cmd);
    wr_le32(&detail[17], s_last_can_tx_cmd);
    wr_le32(&detail[21], s_last_can_tx_data);
    host_link_send_response(seq, CMD_PROGRAM_BLOCK, status, detail, 25u);
#else
    uint8_t detail[20];
    wr_le32(&detail[0], addr);
    wr_le32(&detail[4], expected);
    wr_le32(&detail[8], observed);
    wr_le32(&detail[12], last_rx_cmd);
    wr_le32(&detail[16], last_rx_data);
    host_link_send_response(seq, CMD_PROGRAM_BLOCK, status, detail, 20u);
#endif
}

static void handle_isp_cmd_fixed(const host_request_t *req, uint32_t cmd32, uint32_t timeout_ms)
{
    uint32_t ret_data = 0u;
    uint8_t payload[4];

    if (can_exec_with_retry(cmd32, 0u, timeout_ms, CAN_MAX_RETRY, &ret_data)) {
        wr_le32(payload, ret_data);
        host_link_send_response(req->seq, req->cmd, STATUS_OK, payload, 4u);
    } else {
        send_status_only(req->seq, req->cmd, STATUS_TIMEOUT);
    }
}

static void handle_isp_cmd_addr_data(const host_request_t *req, uint32_t timeout_ms)
{
    uint32_t addr;
    uint32_t data;
    uint32_t ret_data = 0u;
    uint8_t payload[4];

    if (req->payload_len != 8u) {
        send_status_only(req->seq, req->cmd, STATUS_BAD_ARGUMENT);
        return;
    }

    addr = rd_le32(&req->payload[0]);
    data = rd_le32(&req->payload[4]);
    if (can_exec_with_retry(addr, data, timeout_ms, CAN_MAX_RETRY, &ret_data)) {
        wr_le32(payload, ret_data);
        host_link_send_response(req->seq, req->cmd, STATUS_OK, payload, 4u);
    } else {
        send_status_only(req->seq, req->cmd, STATUS_TIMEOUT);
    }
}

static void handle_isp_raw32(const host_request_t *req)
{
    uint32_t cmd32;
    uint32_t data32;
    uint32_t timeout_ms = CAN_CMD_TIMEOUT_MS;
    uint32_t retry_count = CAN_MAX_RETRY;
    uint8_t flags = 0u;
    uint32_t ret_data = 0u;
    uint8_t payload[4];

    if ((req->payload_len != 8u) && (req->payload_len != 12u)) {
        send_status_only(req->seq, req->cmd, STATUS_BAD_ARGUMENT);
        return;
    }

    cmd32 = rd_le32(&req->payload[0]);
    data32 = rd_le32(&req->payload[4]);

    if ((cmd32 == ISP_CMD_READ_CONFIG) ||
            (cmd32 == ISP_CMD_UPDATE_CONFIG) ||
            (cmd32 == ISP_CMD_ERASE_ALL) ||
            (cmd32 == ISP_CMD_READ_CONFIG_EXT) ||
            (cmd32 == ISP_CMD_UPDATE_CONFIG_EXT)) {
        send_status_only(req->seq, req->cmd, STATUS_BAD_COMMAND);
        return;
    }

    if (req->payload_len == 12u) {
        timeout_ms = rd_le16(&req->payload[8]);
        retry_count = req->payload[10];
        flags = req->payload[11];

        if (timeout_ms == 0u) {
            timeout_ms = CAN_CMD_TIMEOUT_MS;
        }
        if (retry_count == 0u) {
            retry_count = CAN_MAX_RETRY;
        }
    }

    if (cmd32 == CAN_CMD_RUN_APROM) {
        if (send_run_aprom_once()) {
            send_status_only(req->seq, req->cmd, STATUS_OK);
        } else {
            send_status_only(req->seq, req->cmd, STATUS_INTERNAL_ERROR);
        }
        return;
    }

    if ((flags & ISP_RAW_FLAG_NO_ACK) != 0u) {
        if (can_send_word(cmd32, data32)) {
            send_status_only(req->seq, req->cmd, STATUS_OK);
        } else {
            send_status_only(req->seq, req->cmd, STATUS_INTERNAL_ERROR);
        }
        return;
    }

    if (can_exec_with_retry(cmd32, data32, timeout_ms, retry_count, &ret_data)) {
        wr_le32(payload, ret_data);
        host_link_send_response(req->seq, req->cmd, STATUS_OK, payload, 4u);
    } else {
        send_status_only(req->seq, req->cmd, STATUS_TIMEOUT);
    }
}

static void handle_ping(const host_request_t *req)
{
    host_link_send_response(req->seq, req->cmd, STATUS_OK, req->payload, req->payload_len);
}

static void handle_set_can_bitrate(const host_request_t *req)
{
    uint32_t bitrate;

    if (req->payload_len != 4u) {
        send_status_only(req->seq, req->cmd, STATUS_BAD_ARGUMENT);
        return;
    }

    bitrate = rd_le32(&req->payload[0]);
    if ((bitrate < 10000u) || (bitrate > 1000000u)) {
        send_status_only(req->seq, req->cmd, STATUS_BAD_ARGUMENT);
        return;
    }

    can_init(bitrate);
    s_bootloader_online = 0u;
    s_bootloader_device_id = 0u;
    s_readcfg_warmup_done = 0u;
    send_status_only(req->seq, req->cmd, STATUS_OK);
}

static void handle_enter_bootloader(const host_request_t *req)
{
    uint32_t ret_data = 0u;
    uint8_t payload[4];

    if (s_bootloader_online != 0u) {
        perform_readcfg_warmup_best_effort();
        wr_le32(payload, s_bootloader_device_id);
        host_link_send_response(req->seq, req->cmd, STATUS_OK, payload, 4u);
        return;
    }

    {
        uint32_t last_rx_cmd = 0u;
        uint32_t last_rx_data = 0u;
        uint8_t diag[9];

        if (can_exec_with_retry_diag(CAN_CMD_GET_DEVICEID,
                                     0u,
                                     CAN_CMD_TIMEOUT_MS,
                                     CAN_MAX_RETRY,
                                     &ret_data,
                                     &last_rx_cmd,
                                     &last_rx_data)) {
        s_run_aprom_sent = 0u;
        s_bootloader_online = 1u;
        s_bootloader_device_id = ret_data;
        perform_readcfg_warmup_best_effort();
        wr_le32(payload, ret_data);
        host_link_send_response(req->seq, req->cmd, STATUS_OK, payload, 4u);
        } else {
        s_bootloader_online = 0u;
        s_bootloader_device_id = 0u;
        s_readcfg_warmup_done = 0u;
        diag[0] = CONNECT_DIAG_PHASE_B1;
        wr_le32(&diag[1], last_rx_cmd);
        wr_le32(&diag[5], last_rx_data);
        host_link_send_response(req->seq, req->cmd, STATUS_TIMEOUT, diag, sizeof(diag));
        }
    }
}

static void handle_erase(const host_request_t *req)
{
    (void)req;
    /* Target ISP_CAN profile does not use A300 erase-all.
     * Flash page erase is handled by target on word-write page boundary.
     */
    s_prog_ctx.active = 0u;
    s_prog_ctx.expected_block_index = 0u;
    s_prog_ctx.programmed_size = 0u;
    s_prog_ctx.crc32_running = 0xFFFFFFFFu;
    program_page_boundary_guard_reset();
    program_page_diag_reset();
    program_queue_reset();
    ack_history_reset();
    send_status_only(req->seq, CMD_ERASE, STATUS_OK);
}

static void handle_program_begin(const host_request_t *req)
{
    uint8_t begin_flags;

    if (req->payload_len != 12u) {
        send_status_only(req->seq, req->cmd, STATUS_BAD_ARGUMENT);
        return;
    }

    s_prog_ctx.active = 1u;
    s_run_aprom_sent = 0u;
    s_prog_ctx.image_size = rd_le32(&req->payload[0]);
    s_prog_ctx.image_crc32 = rd_le32(&req->payload[4]);
    s_prog_ctx.block_size = rd_le16(&req->payload[8]);
    s_prog_ctx.window = 1u;
    begin_flags = req->payload[11];
    s_prog_ctx.ack_trace_word_data = ((begin_flags & PROGRAM_BEGIN_FLAG_ACK_TRACE_WORD_DATA) != 0u) ? 1u : 0u;
    s_prog_ctx.page_diag_enable = ((begin_flags & PROGRAM_BEGIN_FLAG_PAGE_DIAG) != 0u) ? 1u : 0u;

    if ((s_prog_ctx.block_size == 0u) || (s_prog_ctx.block_size > PROGRAM_BLOCK_MAX)) {
        s_prog_ctx.active = 0u;
        send_status_only(req->seq, req->cmd, STATUS_BAD_ARGUMENT);
        return;
    }

    if (!perform_readcfg_warmup()) {
        s_prog_ctx.active = 0u;
        send_status_only(req->seq, req->cmd, STATUS_TIMEOUT);
        return;
    }

    /* payload[11] flags:
     * bit0: disable second-read verification path (reserved compatibility)
     * bit1: include per-word ACK readback data in successful ProgramBlock response
     */
    (void)PROGRAM_BEGIN_FLAG_DISABLE_SECOND_READ;

    s_prog_ctx.expected_block_index = 0u;
    s_prog_ctx.programmed_size = 0u;
    s_prog_ctx.crc32_running = 0xFFFFFFFFu;
    program_page_boundary_guard_reset();
    program_page_diag_reset();

    program_queue_reset();
    ack_history_reset();
    send_status_only(req->seq, req->cmd, STATUS_OK);
}

static void handle_program_block(const host_request_t *req)
{
    uint32_t block_index;
    uint32_t offset;
    uint16_t data_len;
    uint32_t expected_offset;

    if (s_prog_ctx.active == 0u) {
        send_status_only(req->seq, req->cmd, STATUS_BAD_ARGUMENT);
        return;
    }

    if (req->payload_len < 10u) {
        send_status_only(req->seq, req->cmd, STATUS_BAD_ARGUMENT);
        return;
    }

    block_index = rd_le32(&req->payload[0]);
    offset = rd_le32(&req->payload[4]);
    data_len = rd_le16(&req->payload[8]);
    expected_offset = block_index * (uint32_t)s_prog_ctx.block_size;

    if ((data_len == 0u) || (data_len > s_prog_ctx.block_size) || (data_len > PROGRAM_BLOCK_MAX)) {
        send_status_only(req->seq, req->cmd, STATUS_BAD_ARGUMENT);
        return;
    }

    if (req->payload_len != (uint16_t)(10u + data_len)) {
        send_status_only(req->seq, req->cmd, STATUS_BAD_ARGUMENT);
        return;
    }

    if (offset != expected_offset) {
        send_status_only(req->seq, req->cmd, STATUS_SEQUENCE_ERROR);
        return;
    }

    if (block_index < s_prog_ctx.expected_block_index) {
        if (ack_history_match(block_index, req->seq)) {
            send_status_only(req->seq, req->cmd, STATUS_OK);
            return;
        }
        if ((s_prog_exec_valid != 0u) &&
                (s_prog_exec_block_index == block_index) &&
                (s_prog_exec_seq == req->seq)) {
            return;
        }
        if (program_queue_find(block_index, req->seq)) {
            return;
        }
        send_status_only(req->seq, req->cmd, STATUS_SEQUENCE_ERROR);
        return;
    }

    if (block_index != s_prog_ctx.expected_block_index) {
        send_status_only(req->seq, req->cmd, STATUS_SEQUENCE_ERROR);
        return;
    }

    if (s_prog_q_count >= PROGRAM_QUEUE_DEPTH) {
        send_status_only(req->seq, req->cmd, STATUS_BUSY);
        return;
    }

    if (!program_queue_push(req->seq, block_index, offset, &req->payload[10], data_len)) {
        send_status_only(req->seq, req->cmd, STATUS_BUSY);
        return;
    }

    s_prog_ctx.expected_block_index++;
}

static void handle_program_end(const host_request_t *req)
{
    if (s_prog_ctx.active == 0u) {
        send_status_only(req->seq, req->cmd, STATUS_BAD_ARGUMENT);
        return;
    }

    if (s_prog_q_count != 0u) {
        send_status_only(req->seq, req->cmd, STATUS_BUSY);
        return;
    }

    if (s_prog_ctx.page_diag_enable != 0u) {
        uint8_t payload[HOST_MAX_PAYLOAD];
        uint16_t payload_len = build_program_end_diag_payload(payload, HOST_MAX_PAYLOAD);
        host_link_send_response(req->seq, req->cmd, STATUS_OK, payload, payload_len);
    } else {
        send_status_only(req->seq, req->cmd, STATUS_OK);
    }
}

static void handle_verify(const host_request_t *req)
{
    uint32_t req_size;
    uint32_t req_crc;
    uint32_t final_crc;

    if ((s_prog_ctx.active == 0u) || (req->payload_len != 8u)) {
        send_status_only(req->seq, req->cmd, STATUS_BAD_ARGUMENT);
        return;
    }

    req_size = rd_le32(&req->payload[0]);
    req_crc = rd_le32(&req->payload[4]);
    final_crc = ~s_prog_ctx.crc32_running;

    if ((req_size == s_prog_ctx.programmed_size) &&
            (req_crc == final_crc) &&
            (req_size == s_prog_ctx.image_size) &&
            (req_crc == s_prog_ctx.image_crc32)) {
        send_status_only(req->seq, req->cmd, STATUS_OK);
    } else {
        send_status_only(req->seq, req->cmd, STATUS_VERIFY_FAILED);
    }
}

static void handle_run(const host_request_t *req)
{
    if (send_run_aprom_once()) {
        s_bootloader_online = 0u;
        s_readcfg_warmup_done = 0u;
        send_ok_then_reset(req->seq, req->cmd);
    } else {
        send_status_only(req->seq, req->cmd, STATUS_INTERNAL_ERROR);
    }
}

static void handle_verify_readback_block(const host_request_t *req)
{
    send_status_only(req->seq, req->cmd, STATUS_BAD_COMMAND);
}

static void service_program_queue(void)
{
    program_block_item_t item;
    uint8_t ack_trace_payload[1u + PROGRAM_BLOCK_MAX];
    uint32_t i;
    uint32_t ack_data;
    uint32_t fail_addr = 0u;
    uint32_t fail_word = 0u;
    uint32_t fail_ack_or_seen = 0xFFFFFFFFu;
    uint32_t fail_last_rx_cmd = 0u;
    uint32_t fail_last_rx_data = 0u;
    uint8_t fail_reason = DIAG_REASON_NONE;
    uint8_t status = STATUS_OK;

    if (s_prog_ctx.active == 0u) {
        return;
    }

    if (!program_queue_pop(&item)) {
        return;
    }
    s_prog_exec_valid = 1u;
    s_prog_exec_seq = item.seq;
    s_prog_exec_block_index = item.block_index;
    ack_trace_payload[0] = 0u;

    for (i = 0u; i < item.len; i += 4u) {
        uint32_t cmd_addr = item.offset + i;
        uint32_t word = 0xFFFFFFFFu;
        uint32_t copy_len = (item.len - i >= 4u) ? 4u : (item.len - i);
        uint32_t mask = (copy_len >= 4u) ? 0xFFFFFFFFu : ((1u << (copy_len * 8u)) - 1u);
        uint32_t last_rx_cmd = 0u;
        uint32_t last_rx_data = 0u;

        memcpy((uint8_t *)&word, &item.data[i], copy_len);
        fail_addr = cmd_addr;
        fail_word = word;
        if (!program_page_boundary_guard_mark(cmd_addr)) {
            status = STATUS_SEQUENCE_ERROR;
            fail_ack_or_seen = cmd_addr;
            fail_reason = DIAG_REASON_PAGE_REPEAT;
            break;
        }
        /* Program flow is strict one-word-in-flight.  Drop any stale ACK left
         * from the previous word before transmitting the next target command.
         */
        can_drop_stale_rx();
        program_wait_page_boundary_pre_tx_delay(cmd_addr);
        if (s_prog_ctx.page_diag_enable != 0u) {
            program_page_diag_note_tx(cmd_addr, word);
        }
        if (!can_send_word(cmd_addr, word)) {
            status = STATUS_INTERNAL_ERROR;
            fail_ack_or_seen = 0u;
            fail_reason = DIAG_REASON_TX_FAIL;
            break;
        }
        if (!can_wait_ack_blocking(cmd_addr,
                                   &ack_data,
                                   program_word_ack_timeout_ms(cmd_addr),
                                   &last_rx_cmd,
                                   &last_rx_data)) {
            status = STATUS_TIMEOUT;
            fail_last_rx_cmd = last_rx_cmd;
            fail_last_rx_data = last_rx_data;
            fail_ack_or_seen = last_rx_data;
            fail_reason = DIAG_REASON_ACK_TIMEOUT;
            break;
        }
#if (BRIDGE_ACK_STRICT_COMPARE != 0u)
        if ((ack_data & mask) != (word & mask)) {
            status = STATUS_VERIFY_FAILED;
            fail_ack_or_seen = ack_data;
            fail_reason = DIAG_REASON_ACK_MISMATCH;
            break;
        }
        if (s_prog_ctx.page_diag_enable != 0u) {
            program_page_diag_note_ack(cmd_addr, ack_data);
        }
        if (is_page_boundary_addr(cmd_addr) != 0u) {
            if (!bridge_hw_can_tx_cleanup_slot(s_last_can_tx_slot)) {
                status = STATUS_INTERNAL_ERROR;
                fail_ack_or_seen = ack_data;
                fail_reason = DIAG_REASON_TX_CLEANUP_FAIL;
                break;
            }
        }
        program_wait_page_boundary_delay(cmd_addr);
#else
        (void)ack_data;
        (void)mask;
        if (is_page_boundary_addr(cmd_addr) != 0u) {
            if (!bridge_hw_can_tx_cleanup_slot(s_last_can_tx_slot)) {
                status = STATUS_INTERNAL_ERROR;
                fail_ack_or_seen = 0u;
                fail_reason = DIAG_REASON_TX_CLEANUP_FAIL;
                break;
            }
        }
        program_wait_page_boundary_delay(cmd_addr);
#endif
        if (s_prog_ctx.ack_trace_word_data != 0u) {
            uint8_t ack_index = ack_trace_payload[0];
            if ((uint32_t)(1u + ((uint32_t)ack_index + 1u) * 4u) <= sizeof(ack_trace_payload)) {
                wr_le32(&ack_trace_payload[1u + ((uint32_t)ack_index * 4u)], ack_data);
                ack_trace_payload[0] = (uint8_t)(ack_index + 1u);
            }
        }
    }

    if (status == STATUS_OK) {
        s_prog_ctx.crc32_running = crc32_update(s_prog_ctx.crc32_running, item.data, item.len);
        s_prog_ctx.programmed_size += item.len;
        ack_history_put(item.block_index, item.seq);
    } else {
        /* On a failed block, drop speculative queued blocks and roll expected index back
         * so host retries can restart from the failed block cleanly.
         */
        s_prog_ctx.expected_block_index = item.block_index;
        program_queue_reset();
    }

    s_prog_exec_valid = 0u;
    if (status == STATUS_OK) {
        if (s_prog_ctx.ack_trace_word_data != 0u) {
            host_link_send_response(item.seq,
                                    CMD_PROGRAM_BLOCK,
                                    status,
                                    ack_trace_payload,
                                    (uint16_t)(1u + ((uint16_t)ack_trace_payload[0] * 4u)));
        } else {
            send_status_only(item.seq, CMD_PROGRAM_BLOCK, status);
        }
    } else {
        send_program_block_fail(item.seq,
                                status,
                                fail_addr,
                                fail_word,
                                fail_ack_or_seen,
                                fail_last_rx_cmd,
                                fail_last_rx_data,
                                fail_reason);
    }
}

void bridge_nuvoisp_can_init(void)
{
    memset((void *)&s_prog_ctx, 0, sizeof(s_prog_ctx));
    program_queue_reset();
    ack_history_reset();
    s_bootloader_online = 0u;
    s_bootloader_device_id = 0u;
    s_readcfg_warmup_done = 0u;
    can_init(s_can_bitrate);
}

void bridge_nuvoisp_can_tick_1ms(void)
{
    s_ms_ticks++;
}

void bridge_nuvoisp_can_poll(void)
{
    service_program_queue();
}

void bridge_nuvoisp_can_handle_request(const host_request_t *req)
{
    if (req == NULL) {
        return;
    }

    switch (req->cmd) {
        case CMD_PING:
            handle_ping(req);
            break;
        case CMD_SET_CAN_BITRATE:
            handle_set_can_bitrate(req);
            break;
        case CMD_ENTER_BOOTLOADER:
            handle_enter_bootloader(req);
            break;
        case CMD_ERASE:
            handle_erase(req);
            break;
        case CMD_PROGRAM_BEGIN:
            handle_program_begin(req);
            break;
        case CMD_PROGRAM_BLOCK:
            handle_program_block(req);
            break;
        case CMD_PROGRAM_END:
            handle_program_end(req);
            break;
        case CMD_VERIFY:
            handle_verify(req);
            break;
        case CMD_RUN:
            handle_run(req);
            break;
        case CMD_VERIFY_READBACK_BLOCK:
            handle_verify_readback_block(req);
            break;
        case CMD_ISP_GET_VERSION:
            handle_isp_cmd_fixed(req, ISP_CMD_GET_VERSION, CAN_CMD_TIMEOUT_MS);
            break;
        case CMD_ISP_CONNECT:
            handle_isp_cmd_fixed(req, ISP_CMD_CONNECT, CAN_CMD_TIMEOUT_MS);
            break;
        case CMD_ISP_SYNC_PACKNO:
            handle_isp_cmd_fixed(req, ISP_CMD_SYNC_PACKNO, CAN_CMD_TIMEOUT_MS);
            break;
        case CMD_ISP_GET_DEVICEID:
            handle_isp_cmd_fixed(req, ISP_CMD_GET_DEVICEID, CAN_CMD_TIMEOUT_MS);
            break;
        case CMD_ISP_READ_CONFIG:
            send_status_only(req->seq, req->cmd, STATUS_BAD_COMMAND);
            break;
        case CMD_ISP_UPDATE_CONFIG:
            send_status_only(req->seq, req->cmd, STATUS_BAD_COMMAND);
            break;
        case CMD_ISP_UPDATE_APROM_WORD:
            handle_isp_cmd_addr_data(req, CAN_ACK_TIMEOUT_MS);
            break;
        case CMD_ISP_UPDATE_DATAFLASH_WORD:
            handle_isp_cmd_addr_data(req, CAN_ACK_TIMEOUT_MS);
            break;
        case CMD_ISP_ERASE_ALL:
            send_status_only(req->seq, req->cmd, STATUS_BAD_COMMAND);
            break;
        case CMD_ISP_RUN_APROM:
            if (send_run_aprom_once()) {
                send_ok_then_reset(req->seq, req->cmd);
            } else {
                send_status_only(req->seq, req->cmd, STATUS_INTERNAL_ERROR);
            }
            break;
        case CMD_ISP_RUN_LDROM:
            handle_isp_cmd_fixed(req, ISP_CMD_RUN_LDROM, CAN_CMD_TIMEOUT_MS);
            break;
        case CMD_ISP_RESET:
            handle_isp_cmd_fixed(req, ISP_CMD_RESET, CAN_CMD_TIMEOUT_MS);
            break;
        case CMD_ISP_RESEND_PACKET:
            handle_isp_cmd_fixed(req, ISP_CMD_RESEND_PACKET, CAN_CMD_TIMEOUT_MS);
            break;
        case CMD_ISP_ERASE_SPIFLASH:
            handle_isp_cmd_fixed(req, ISP_CMD_ERASE_SPIFLASH, CAN_ERASE_TIMEOUT_MS);
            break;
        case CMD_ISP_UPDATE_SPIFLASH_WORD:
            handle_isp_cmd_addr_data(req, CAN_ACK_TIMEOUT_MS);
            break;
        case CMD_ISP_CAN_GET_DEVICEID:
            handle_isp_cmd_fixed(req, CAN_CMD_GET_DEVICEID, CAN_CMD_TIMEOUT_MS);
            break;
        case CMD_ISP_CAN_READ_CONFIG:
            send_status_only(req->seq, req->cmd, STATUS_BAD_COMMAND);
            break;
        case CMD_ISP_CAN_RUN_APROM:
            if (send_run_aprom_once()) {
                send_ok_then_reset(req->seq, req->cmd);
            } else {
                send_status_only(req->seq, req->cmd, STATUS_INTERNAL_ERROR);
            }
            break;
        case CMD_ISP_RAW32:
            handle_isp_raw32(req);
            break;
        default:
            send_status_only(req->seq, req->cmd, STATUS_BAD_COMMAND);
            break;
    }
}
