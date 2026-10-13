#ifndef BRIDGE_BOARD_CONFIG_H
#define BRIDGE_BOARD_CONFIG_H

#include "NuMicro.h"

#define BRIDGE_UART_DEFAULT_BAUDRATE                (115200u)
#define BRIDGE_CAN_DEFAULT_BITRATE                  (500000u)
#define BRIDGE_ACK_STRICT_COMPARE                   (1u)
#define BRIDGE_DIAG_MINIMAL_ENABLE                  (1u)
#define BRIDGE_RUN_UART_FLUSH_TIMEOUT_MS            (10u)
#define BRIDGE_CAN_TX_HW_WAIT_MS                    (5u)
#define BRIDGE_CAN_TX_GAP_DIAG_MS                   (0u)
#define BRIDGE_TARGET_PAGE_BOUNDARY_DELAY_ENABLE    (1u)
#define BRIDGE_TARGET_PAGE_BOUNDARY_BYTES           (512u)
#define BRIDGE_TARGET_PAGE_BOUNDARY_DELAY_MS        (100u)
#define BRIDGE_TARGET_PAGE_ERASE_DIAG_ENABLE        (1u)
#define BRIDGE_TARGET_PAGE_SIZE_DIAG_BYTES          (512u)
#define BRIDGE_TARGET_PAGE_ERASE_GUARD_BYTES        (4u)
#define BRIDGE_TARGET_PAGE_ERASE_ACK_TIMEOUT_MS     (15000u)

#include "bridge_board_config_m0a23.h"

#ifndef BRIDGE_BOARD_EXTRA_INIT
#define BRIDGE_BOARD_EXTRA_INIT()                    do { } while (0)
#endif

#endif
