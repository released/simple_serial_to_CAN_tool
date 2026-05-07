#ifndef BRIDGE_HW_ABSTRACTION_H
#define BRIDGE_HW_ABSTRACTION_H

#include <stdint.h>

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

#endif

