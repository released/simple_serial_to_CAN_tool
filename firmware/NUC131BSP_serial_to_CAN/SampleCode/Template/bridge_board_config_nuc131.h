#ifndef BRIDGE_BOARD_CONFIG_NUC131_H
#define BRIDGE_BOARD_CONFIG_NUC131_H

#define BRIDGE_PLATFORM_NAME                         "NUC131"

/* BSP reference: Nuvoton NUC131BSP
 * User-provided EVB pins, BSP double-confirmed in sys.h:
 *   UART0 RX/TX: PB0 / PB1
 *   CAN0 RX/TX:  PD6 / PD7
 *   CAN transceiver pin#8 enable must be driven LOW:
 *     CAN0: PC15
 */
#define BRIDGE_UART_INSTANCE_INDEX                   (0u)
#define BRIDGE_CAN_INSTANCE_INDEX                    (0u)

#define BRIDGE_UART_PORT                             UART0
#define BRIDGE_UART_MODULE                           UART0_MODULE
#define BRIDGE_UART_RESET                            UART0_RST
#define BRIDGE_UART_CLKSEL                           CLK_CLKSEL1_UART_S_HIRC
#define BRIDGE_UART_CLKDIV                           CLK_CLKDIV_UART(1)
#define BRIDGE_UART_IRQn_ID                          UART02_IRQn
#define BRIDGE_UART_IRQ_HANDLER_NAME                 UART02_IRQHandler

#define BRIDGE_CAN_PORT                              CAN0
#define BRIDGE_CAN_MODULE                            CAN0_MODULE
#define BRIDGE_CAN_RESET                             CAN0_RST
#define BRIDGE_CAN_IRQn_ID                           CAN0_IRQn
#define BRIDGE_CAN_IRQ_HANDLER_NAME                  CAN0_IRQHandler
#define BRIDGE_CAN_RX_MSG_OBJ_BASE                   0u
#define BRIDGE_CAN_RX_SLOT_COUNT                     (1u)
#define BRIDGE_CAN_TX_MSG_OBJ_BASE                   5u
#define BRIDGE_CAN_TX_SLOT_COUNT                     (1u)

#define BRIDGE_BOARD_PINMUX_INIT()                                                 \
    do {                                                                           \
        SYS->GPD_MFP &= ~(SYS_GPD_MFP_PD6_Msk | SYS_GPD_MFP_PD7_Msk);              \
        SYS->GPD_MFP |= (SYS_GPD_MFP_PD6_CAN0_RXD | SYS_GPD_MFP_PD7_CAN0_TXD);     \
        SYS->GPB_MFP &= ~(SYS_GPB_MFP_PB0_Msk | SYS_GPB_MFP_PB1_Msk);              \
        SYS->GPB_MFP |= (SYS_GPB_MFP_PB0_UART0_RXD | SYS_GPB_MFP_PB1_UART0_TXD);   \
    } while (0)

#endif

#define BRIDGE_BOARD_EXTRA_INIT()                                                  \
    do {                                                                           \
        GPIO_SetMode(PC, BIT15, GPIO_PMD_OUTPUT);                                   \
        PC15 = 0u;                                                                  \
    } while (0)

