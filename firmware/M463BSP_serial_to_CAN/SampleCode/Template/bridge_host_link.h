#ifndef BRIDGE_HOST_LINK_H
#define BRIDGE_HOST_LINK_H

#include <stdint.h>

#define HOST_MAX_PAYLOAD                (96u)

typedef struct {
    uint16_t seq;
    uint8_t cmd;
    uint16_t payload_len;
    uint16_t payload_crc;
    uint8_t payload[HOST_MAX_PAYLOAD];
} host_request_t;

typedef void (*host_request_handler_t)(const host_request_t *req);

void host_link_init(host_request_handler_t handler);
void host_link_poll_uart(void);
void host_link_feed_bytes(const uint8_t *data, uint16_t len); /* reserved for HID path */
void host_link_send_response(uint16_t seq,
                             uint8_t cmd,
                             uint8_t status,
                             const uint8_t *payload,
                             uint16_t payload_len);

#endif
