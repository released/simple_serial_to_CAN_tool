#ifndef BRIDGE_BOARD_CONFIG_M2A23_H
#define BRIDGE_BOARD_CONFIG_M2A23_H

#define BRIDGE_PLATFORM_NAME                         "M2A23"

/* BSP reference: Nuvoton m2a23bsp
 * User-provided EVB pins, BSP confirmed in sys.h:
 *   UART0 RX/TX: PB12 / PB13
 *   CANFD0 RX/TX: PC4 / PC5
 */
#define BRIDGE_UART_INSTANCE_INDEX                   (0u)
#define BRIDGE_CAN_INSTANCE_INDEX                    (0u)

#define BRIDGE_UART_PORT                             UART0
#define BRIDGE_UART_MODULE                           UART0_MODULE
#define BRIDGE_UART_RESET                            UART0_RST
#define BRIDGE_UART_CLKSEL                           CLK_CLKSEL2_UART0SEL_HIRC
#define BRIDGE_UART_CLKDIV                           CLK_CLKDIV0_UART0(1)
#define BRIDGE_UART_IRQn_ID                          UART0_IRQn
#define BRIDGE_UART_IRQ_HANDLER_NAME                 UART0_IRQHandler

#define BRIDGE_CAN_PORT                              CANFD0
#define BRIDGE_CAN_MODULE                            CANFD0_MODULE
#define BRIDGE_CAN_RESET                             CANFD0_RST
#define BRIDGE_CAN_IRQn_ID                           CANFD00_IRQn
#define BRIDGE_CAN_IRQ_HANDLER_NAME                  CANFD00_IRQHandler
#define BRIDGE_CAN_RX_MSG_OBJ_BASE                   0u
#define BRIDGE_CAN_RX_SLOT_COUNT                     (1u)
#define BRIDGE_CAN_TX_MSG_OBJ_BASE                   0u
#define BRIDGE_CAN_TX_SLOT_COUNT                     (1u)

#define BRIDGE_BOARD_PINMUX_INIT()                                                 \
    do {                                                                           \
        SET_UART0_RXD_PB12();                                                      \
        SET_UART0_TXD_PB13();                                                      \
        SET_CANFD0_RXD_PC4();                                                      \
        SET_CANFD0_TXD_PC5();                                                      \
    } while (0)

#endif

