#ifndef BRIDGE_NUVOISP_CAN_H
#define BRIDGE_NUVOISP_CAN_H

#include "bridge_host_link.h"

void bridge_nuvoisp_can_init(void);
void bridge_nuvoisp_can_tick_1ms(void);
void bridge_nuvoisp_can_poll(void);
void bridge_nuvoisp_can_handle_request(const host_request_t *req);

#endif
