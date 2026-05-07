#ifndef BRIDGE_BOARD_CONFIG_M253_H
#define BRIDGE_BOARD_CONFIG_M253_H

#define BRIDGE_PLATFORM_NAME                         "M253"

/* BSP reference: Nuvoton M253BSP
 * User-provided EVB pins, BSP double-confirmed in sys.h:
 *   UART4 RX/TX: PA2 / PA3
 *   CAN0 RX/TX:  PC4 / PC5
 * Driver family on M253 is CANFD0 (classical CAN mode over CANFD IP).
 */
#define BRIDGE_UART_INSTANCE_INDEX                   (4u)
#define BRIDGE_CAN_INSTANCE_INDEX                    (0u)

#define BRIDGE_UART_PORT                             UART4
#define BRIDGE_UART_MODULE                           UART4_MODULE
#define BRIDGE_UART_RESET                            UART4_RST
#define BRIDGE_UART_CLKSEL                           CLK_CLKSEL3_UART4SEL_HIRC
#define BRIDGE_UART_CLKDIV                           CLK_CLKDIV4_UART4(1)
#define BRIDGE_UART_IRQn_ID                          UART4_IRQn
#define BRIDGE_UART_IRQ_HANDLER_NAME                 UART4_IRQHandler

#define BRIDGE_CAN_PORT                              CANFD0
#define BRIDGE_CAN_MODULE                            CANFD0_MODULE
#define BRIDGE_CAN_RESET                             CANFD0_RST
#define BRIDGE_CAN_IRQn_ID                           CANFD0_IRQ0_IRQn
#define BRIDGE_CAN_IRQ_HANDLER_NAME                  CANFD0_IRQ0_IRQHandler
#define BRIDGE_CAN_RX_MSG_OBJ_BASE                   0u
#define BRIDGE_CAN_RX_SLOT_COUNT                     (1u)
#define BRIDGE_CAN_TX_MSG_OBJ_BASE                   0u
#define BRIDGE_CAN_TX_SLOT_COUNT                     (1u)

#define BRIDGE_BOARD_PINMUX_INIT()                                                 \
    do {                                                                           \
        SYS->GPA_MFPL = (SYS->GPA_MFPL & ~SYS_GPA_MFPL_PA2MFP_Msk) |               \
                        SYS_GPA_MFPL_PA2MFP_UART4_RXD;                             \
        SYS->GPA_MFPL = (SYS->GPA_MFPL & ~SYS_GPA_MFPL_PA3MFP_Msk) |               \
                        SYS_GPA_MFPL_PA3MFP_UART4_TXD;                             \
        SYS->GPC_MFPL = (SYS->GPC_MFPL & ~SYS_GPC_MFPL_PC4MFP_Msk) |               \
                        SYS_GPC_MFPL_PC4MFP_CAN0_RXD;                              \
        SYS->GPC_MFPL = (SYS->GPC_MFPL & ~SYS_GPC_MFPL_PC5MFP_Msk) |               \
                        SYS_GPC_MFPL_PC5MFP_CAN0_TXD;                              \
    } while (0)

#endif

