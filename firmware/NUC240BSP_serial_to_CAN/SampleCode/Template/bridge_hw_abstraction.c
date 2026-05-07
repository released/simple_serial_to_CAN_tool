#include "NuMicro.h"
#include "bridge_board_config.h"
#include "bridge_hw_abstraction.h"
#include "bridge_can_backend.h"
#define UART_RX_RING_SIZE               (512u)
#define CAN_RX_QUEUE_SIZE               (8u)
#define PLL_CLOCK                       48000000

typedef struct
{
    uint32_t cmd;
    uint32_t data;
} bridge_can_rx_item_t;

static volatile uint8_t s_uart_rx_ring[UART_RX_RING_SIZE];
static volatile uint16_t s_uart_rx_head;
static volatile uint16_t s_uart_rx_tail;

static volatile bridge_can_rx_item_t s_can_rx_queue[CAN_RX_QUEUE_SIZE];
static volatile uint8_t s_can_rx_q_head;
static volatile uint8_t s_can_rx_q_tail;
static volatile uint8_t s_can_rx_q_count;

static uint32_t s_can_bitrate = BRIDGE_CAN_DEFAULT_BITRATE;

static void bridge_hw_can_queue_push(uint32_t cmd, uint32_t data)
{
    __disable_irq();
    if (s_can_rx_q_count >= CAN_RX_QUEUE_SIZE) {
        s_can_rx_q_tail = (uint8_t)((s_can_rx_q_tail + 1u) % CAN_RX_QUEUE_SIZE);
        s_can_rx_q_count--;
    }
    s_can_rx_queue[s_can_rx_q_head].cmd = cmd;
    s_can_rx_queue[s_can_rx_q_head].data = data;
    s_can_rx_q_head = (uint8_t)((s_can_rx_q_head + 1u) % CAN_RX_QUEUE_SIZE);
    s_can_rx_q_count++;
    __enable_irq();
}

void bridge_hw_board_init(void)
{
    SYS_UnlockReg();

    CLK_EnableXtalRC(CLK_PWRCON_OSC22M_EN_Msk);
    CLK_WaitClockReady(CLK_CLKSTATUS_OSC22M_STB_Msk);

    CLK_EnableXtalRC(CLK_PWRCON_XTL12M_EN_Msk);
    CLK_WaitClockReady(CLK_CLKSTATUS_XTL12M_STB_Msk);

    CLK_SetHCLK(CLK_CLKSEL0_HCLK_S_HIRC, CLK_CLKDIV_HCLK(1));
    CLK_SetCoreClock(PLL_CLOCK);

    CLK_EnableModuleClock(BRIDGE_UART_MODULE);
    CLK_SetModuleClock(BRIDGE_UART_MODULE, BRIDGE_UART_CLKSEL, BRIDGE_UART_CLKDIV);

    CLK_EnableModuleClock(BRIDGE_CAN_MODULE);

    BRIDGE_BOARD_PINMUX_INIT();
    BRIDGE_BOARD_EXTRA_INIT();

    SystemCoreClockUpdate();
    SYS_LockReg();
}

void bridge_hw_uart_init(void)
{
    s_uart_rx_head = 0u;
    s_uart_rx_tail = 0u;

    SYS_ResetModule(BRIDGE_UART_RESET);
    UART_Open(BRIDGE_UART_PORT, BRIDGE_UART_DEFAULT_BAUDRATE);
    UART_EnableInt(BRIDGE_UART_PORT, UART_IER_RDA_IEN_Msk | UART_IER_TOUT_IEN_Msk);
    NVIC_EnableIRQ(BRIDGE_UART_IRQn_ID);
}

void bridge_hw_can_init(uint32_t bitrate)
{
    s_can_rx_q_head = 0u;
    s_can_rx_q_tail = 0u;
    s_can_rx_q_count = 0u;
    s_can_bitrate = bridge_can_backend_open(bitrate);
}

uint32_t bridge_hw_can_get_bitrate(void)
{
    return s_can_bitrate;
}

void bridge_hw_can_set_rx_filter(uint16_t std_id)
{
    bridge_can_backend_set_rx_filter(std_id);
}

void bridge_hw_can_stop(void)
{
    bridge_can_backend_stop();

    __disable_irq();
    s_can_rx_q_head = 0u;
    s_can_rx_q_tail = 0u;
    s_can_rx_q_count = 0u;
    __enable_irq();
}

uint8_t bridge_hw_can_tx_cleanup_slot(uint8_t tx_slot)
{
    return bridge_can_backend_tx_cleanup_slot(tx_slot);
}

void bridge_hw_system_reset(void)
{
    SYS_UnlockReg();
    SYS_ResetChip();
}

void bridge_hw_uart_send_bytes(const uint8_t *data, uint16_t len)
{
    uint16_t i;

    for (i = 0u; i < len; i++) {
        while (UART_IS_TX_FULL(BRIDGE_UART_PORT)) {
        }
        UART_WRITE(BRIDGE_UART_PORT, data[i]);
    }
}

void bridge_hw_uart_wait_tx_empty(void)
{
    UART_WAIT_TX_EMPTY(BRIDGE_UART_PORT);
}

uint8_t bridge_hw_uart_wait_tx_empty_timeout(uint32_t timeout_ms)
{
    uint32_t count = 0u;
    const uint32_t budget = timeout_ms * 800u;
    while (!UART_IS_TX_EMPTY(BRIDGE_UART_PORT)) {
        count++;
        if (count >= budget) {
            return 0u;
        }
    }
    return 1u;
}

uint8_t bridge_hw_uart_try_pop_byte(uint8_t *out)
{
    uint16_t next_tail;

    if (s_uart_rx_tail == s_uart_rx_head) {
        return 0u;
    }

    *out = s_uart_rx_ring[s_uart_rx_tail];
    next_tail = (uint16_t)((s_uart_rx_tail + 1u) % UART_RX_RING_SIZE);
    s_uart_rx_tail = next_tail;
    return 1u;
}

uint8_t bridge_hw_can_send_cmd_data(uint16_t std_id, uint32_t cmd, uint32_t data)
{
    return bridge_hw_can_send_cmd_data_slot(0u, std_id, cmd, data);
}

uint8_t bridge_hw_can_send_cmd_data_slot(uint8_t tx_slot, uint16_t std_id, uint32_t cmd, uint32_t data)
{
    return bridge_can_backend_send_slot(tx_slot, std_id, cmd, data);
}

uint8_t bridge_hw_can_try_read_cmd_data(uint32_t *cmd, uint32_t *data)
{
    bridge_can_rx_item_t rx;

    __disable_irq();
    if (s_can_rx_q_count == 0u) {
        __enable_irq();
        return 0u;
    }
    rx = s_can_rx_queue[s_can_rx_q_tail];
    s_can_rx_q_tail = (uint8_t)((s_can_rx_q_tail + 1u) % CAN_RX_QUEUE_SIZE);
    s_can_rx_q_count--;
    __enable_irq();

    if (cmd != NULL) {
        *cmd = rx.cmd;
    }
    if (data != NULL) {
        *data = rx.data;
    }

    return 1u;
}

void BRIDGE_UART_IRQ_HANDLER_NAME(void)
{
    if (UART_GET_INT_FLAG(BRIDGE_UART_PORT, UART_ISR_RDA_INT_Msk | UART_ISR_TOUT_INT_Msk)) {
        while (UART_GET_RX_EMPTY(BRIDGE_UART_PORT) == 0u) {
            uint8_t ch = (uint8_t)UART_READ(BRIDGE_UART_PORT);
            uint16_t next_head = (uint16_t)((s_uart_rx_head + 1u) % UART_RX_RING_SIZE);
            if (next_head != s_uart_rx_tail) {
                s_uart_rx_ring[s_uart_rx_head] = ch;
                s_uart_rx_head = next_head;
            }
        }
    }

    if (BRIDGE_UART_PORT->FSR & (UART_FSR_BIF_Msk | UART_FSR_FEF_Msk |
                                     UART_FSR_PEF_Msk | UART_FSR_RX_OVER_IF_Msk)) {
        UART_ClearIntFlag(BRIDGE_UART_PORT, UART_ISR_RLS_INT_Msk | UART_ISR_BUF_ERR_INT_Msk);
    }
}

void BRIDGE_CAN_IRQ_HANDLER_NAME(void)
{
    bridge_can_backend_handle_irq(bridge_hw_can_queue_push);
}


