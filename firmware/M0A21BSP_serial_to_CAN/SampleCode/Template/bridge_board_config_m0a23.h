#ifndef BRIDGE_BOARD_CONFIG_M0A23_H
#define BRIDGE_BOARD_CONFIG_M0A23_H

#define BRIDGE_PLATFORM_NAME                         "M0A23"

/* M0A23 family current baseline. */
#define BRIDGE_UART_INSTANCE_INDEX                   (0u)      /* 0 or 1 */
#define BRIDGE_CAN_INSTANCE_INDEX                    (0u)      /* CAN0 only */

#if (BRIDGE_UART_INSTANCE_INDEX == 0u)
#define BRIDGE_UART_PORT                             UART0
#define BRIDGE_UART_MODULE                           UART0_MODULE
#define BRIDGE_UART_RESET                            UART0_RST
#define BRIDGE_UART_CLKSEL                           CLK_CLKSEL1_UART0SEL_HIRC
#define BRIDGE_UART_CLKDIV                           CLK_CLKDIV0_UART0(1)
#define BRIDGE_UART_IRQn_ID                          UART0_IRQn
#define BRIDGE_UART_IRQ_HANDLER_NAME                 UART0_IRQHandler
#elif (BRIDGE_UART_INSTANCE_INDEX == 1u)
#define BRIDGE_UART_PORT                             UART1
#define BRIDGE_UART_MODULE                           UART1_MODULE
#define BRIDGE_UART_RESET                            UART1_RST
#define BRIDGE_UART_CLKSEL                           CLK_CLKSEL1_UART1SEL_HIRC
#define BRIDGE_UART_CLKDIV                           CLK_CLKDIV0_UART1(1)
#define BRIDGE_UART_IRQn_ID                          UART1_IRQn
#define BRIDGE_UART_IRQ_HANDLER_NAME                 UART1_IRQHandler
#else
#error "Unsupported BRIDGE_UART_INSTANCE_INDEX for M0A23."
#endif

#if (BRIDGE_CAN_INSTANCE_INDEX == 0u)
#define BRIDGE_CAN_PORT                              CAN
#define BRIDGE_CAN_MODULE                            CAN0_MODULE
#define BRIDGE_CAN_RESET                             CAN0_RST
#define BRIDGE_CAN_IRQn_ID                           CAN0_IRQn
#define BRIDGE_CAN_IRQ_HANDLER_NAME                  CAN0_IRQHandler
#define BRIDGE_CAN_RX_MSG_OBJ_BASE                   MSG(0)
#define BRIDGE_CAN_RX_SLOT_COUNT                     (1u)
#define BRIDGE_CAN_TX_MSG_OBJ_BASE                   MSG(5)
#define BRIDGE_CAN_TX_SLOT_COUNT                     (1u)
#else
#error "M0A23 only supports CAN0."
#endif

#define BRIDGE_BOARD_PINMUX_INIT()                                                 \
    do {                                                                           \
        SYS->GPB_MFP1 = (SYS->GPB_MFP1 & ~SYS_GPB_MFP1_PB4MFP_Msk) |               \
                        SYS_GPB_MFP1_PB4MFP_UART0_TXD;                             \
        SYS->GPB_MFP1 = (SYS->GPB_MFP1 & ~SYS_GPB_MFP1_PB6MFP_Msk) |               \
                        SYS_GPB_MFP1_PB6MFP_UART0_RXD;                             \
        SYS->GPB_MFP1 = (SYS->GPB_MFP1 & ~SYS_GPB_MFP1_PB7MFP_Msk) |               \
                        SYS_GPB_MFP1_PB7MFP_CAN0_TXD;                              \
        SYS->GPB_MFP1 = (SYS->GPB_MFP1 & ~SYS_GPB_MFP1_PB5MFP_Msk) |               \
                        SYS_GPB_MFP1_PB5MFP_CAN0_RXD;                              \
    } while (0)

#endif
