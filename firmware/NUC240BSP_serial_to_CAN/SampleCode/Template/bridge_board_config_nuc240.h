#ifndef BRIDGE_BOARD_CONFIG_NUC240_H
#define BRIDGE_BOARD_CONFIG_NUC240_H

#define BRIDGE_PLATFORM_NAME                         "NUC240"

/* BSP reference: Nuvoton NUC230_240BSP
 * User-provided EVB pins, BSP double-confirmed in sys.h:
 *   UART0 RX/TX: PB0 / PB1
 *   CAN0 RX/TX:  PD6 / PD7
 *   Alternate CAN1 RX/TX: PD14 / PD15
 *   CAN transceiver pin#8 enable must be driven LOW:
 *     CAN0: PB3
 *     CAN1: PC5
 */
#define BRIDGE_UART_INSTANCE_INDEX                   (0u)
#define BRIDGE_CAN_INSTANCE_INDEX                    (0u)      /* 0=CAN0, 1=CAN1 */

#define BRIDGE_UART_PORT                             UART0
#define BRIDGE_UART_MODULE                           UART0_MODULE
#define BRIDGE_UART_RESET                            UART0_RST
#define BRIDGE_UART_CLKSEL                           CLK_CLKSEL1_UART_S_HIRC
#define BRIDGE_UART_CLKDIV                           CLK_CLKDIV_UART(1)
#define BRIDGE_UART_IRQn_ID                          UART02_IRQn
#define BRIDGE_UART_IRQ_HANDLER_NAME                 UART02_IRQHandler

#if (BRIDGE_CAN_INSTANCE_INDEX == 0u)
#define BRIDGE_CAN_PORT                              CAN0
#define BRIDGE_CAN_MODULE                            CAN0_MODULE
#define BRIDGE_CAN_RESET                             CAN0_RST
#define BRIDGE_CAN_IRQn_ID                           CAN0_IRQn
#define BRIDGE_CAN_IRQ_HANDLER_NAME                  CAN0_IRQHandler
#define BRIDGE_BOARD_CAN_PINMUX_INIT()                                              \
    do {                                                                           \
        SYS->GPD_MFP &= ~(SYS_GPD_MFP_PD6_Msk | SYS_GPD_MFP_PD7_Msk);              \
        SYS->GPD_MFP |= (SYS_GPD_MFP_PD6_CAN0_RXD | SYS_GPD_MFP_PD7_CAN0_TXD);     \
    } while (0)
#elif (BRIDGE_CAN_INSTANCE_INDEX == 1u)
#define BRIDGE_CAN_PORT                              CAN1
#define BRIDGE_CAN_MODULE                            CAN1_MODULE
#define BRIDGE_CAN_RESET                             CAN1_RST
#define BRIDGE_CAN_IRQn_ID                           CAN1_IRQn
#define BRIDGE_CAN_IRQ_HANDLER_NAME                  CAN1_IRQHandler
#define BRIDGE_BOARD_CAN_PINMUX_INIT()                                              \
    do {                                                                           \
        SYS->GPD_MFP &= ~(SYS_GPD_MFP_PD14_Msk | SYS_GPD_MFP_PD15_Msk);            \
        SYS->GPD_MFP |= (SYS_GPD_MFP_PD14_CAN1_RXD | SYS_GPD_MFP_PD15_CAN1_TXD);   \
    } while (0)
#else
#error "Unsupported BRIDGE_CAN_INSTANCE_INDEX for NUC240."
#endif

#define BRIDGE_CAN_RX_MSG_OBJ_BASE                   0u
#define BRIDGE_CAN_RX_SLOT_COUNT                     (1u)
#define BRIDGE_CAN_TX_MSG_OBJ_BASE                   5u
#define BRIDGE_CAN_TX_SLOT_COUNT                     (1u)

#define BRIDGE_BOARD_PINMUX_INIT()                                                 \
    do {                                                                           \
        SYS->GPB_MFP &= ~(SYS_GPB_MFP_PB0_Msk | SYS_GPB_MFP_PB1_Msk);              \
        SYS->GPB_MFP |= (SYS_GPB_MFP_PB0_UART0_RXD | SYS_GPB_MFP_PB1_UART0_TXD);   \
        BRIDGE_BOARD_CAN_PINMUX_INIT();                                             \
    } while (0)

#if (BRIDGE_CAN_INSTANCE_INDEX == 0u)
#define BRIDGE_BOARD_EXTRA_INIT()                                                  \
    do {                                                                           \
        GPIO_SetMode(PE, BIT2, GPIO_PMD_OUTPUT);                                   \
        PE2 = 0u;                                                                  \
        GPIO_SetMode(PE, BIT3, GPIO_PMD_OUTPUT);                                   \
        PE3 = 0u;                                                                  \
    } while (0)
#else
#define BRIDGE_BOARD_EXTRA_INIT()                                                  \
    do {                                                                           \
        GPIO_SetMode(PE, BIT4, GPIO_PMD_OUTPUT);                                   \
        PE4 = 0u;                                                                  \
        GPIO_SetMode(PE, BIT6, GPIO_PMD_OUTPUT);                                   \
        PE6 = 0u;                                                                  \
    } while (0)
#endif

#endif
