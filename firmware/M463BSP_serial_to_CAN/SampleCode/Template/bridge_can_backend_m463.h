#ifndef BRIDGE_CAN_BACKEND_M463_H

#include <string.h>

static uint16_t s_bridge_can_backend_rx_filter_id;

static uint32_t bridge_can_backend_rd_le32(const uint8_t *p)
{
    return ((uint32_t)p[0]) |
           ((uint32_t)p[1] << 8) |
           ((uint32_t)p[2] << 16) |
           ((uint32_t)p[3] << 24);
}

static void bridge_can_backend_wr_le32(uint8_t *p, uint32_t v)
{
    p[0] = (uint8_t)(v & 0xFFu);
    p[1] = (uint8_t)((v >> 8) & 0xFFu);
    p[2] = (uint8_t)((v >> 16) & 0xFFu);
    p[3] = (uint8_t)((v >> 24) & 0xFFu);
}

static void bridge_can_backend_set_rx_filter(uint16_t rx_filter_id)
{
    s_bridge_can_backend_rx_filter_id = rx_filter_id;
}

static uint32_t bridge_can_backend_open(uint32_t bitrate)
{
    CANFD_FD_T config;

    CANFD_GetDefaultConfig(&config, CANFD_OP_CAN_MODE);
    config.sBtConfig.sNormBitRate.u32BitRate = bitrate;
    CANFD_Open(BRIDGE_CAN_PORT, &config);
    CANFD_SetSIDFltr(BRIDGE_CAN_PORT, 0u, CANFD_RX_FIFO0_STD_MASK(s_bridge_can_backend_rx_filter_id, 0x7FFu));
    CANFD_ClearStatusFlag(BRIDGE_CAN_PORT, CANFD_INT_ALL_SIGNALS);
    CANFD_EnableInt(BRIDGE_CAN_PORT,
                    CANFD_IE_RF0NE_Msk | CANFD_IE_RF0FE_Msk | CANFD_IE_RF0LE_Msk,
                    0u,
                    0u,
                    0u);
    CANFD_RunToNormal(BRIDGE_CAN_PORT, TRUE);

    NVIC_SetPriority(BRIDGE_CAN_IRQn_ID, (1u << __NVIC_PRIO_BITS) - 2u);
    NVIC_EnableIRQ(BRIDGE_CAN_IRQn_ID);
    return bitrate;
}

static void bridge_can_backend_stop(void)
{
    CANFD_DisableInt(BRIDGE_CAN_PORT, CANFD_INT_ALL_SIGNALS, CANFD_INT_ALL_SIGNALS, 0xFFFFFFFFu, 0xFFFFFFFFu);
    NVIC_DisableIRQ(BRIDGE_CAN_IRQn_ID);
    SYS_UnlockReg();
    SYS_ResetModule(BRIDGE_CAN_RESET);
    SYS_LockReg();
}

static uint8_t bridge_can_backend_tx_cleanup_slot(uint8_t tx_slot)
{
    (void)tx_slot;
    return 1u;
}

static uint8_t bridge_can_backend_send_slot(uint8_t tx_slot, uint16_t std_id, uint32_t cmd, uint32_t data)
{
    CANFD_FD_MSG_T tx_msg;
    uint32_t result;

    memset(&tx_msg, 0, sizeof(tx_msg));
    tx_msg.eIdType = eCANFD_SID;
    tx_msg.eFrmType = eCANFD_DATA_FRM;
    tx_msg.u32Id = (uint32_t)(std_id & 0x7FFu);
    tx_msg.u32DLC = 8u;
    bridge_can_backend_wr_le32(&tx_msg.au8Data[0], cmd);
    bridge_can_backend_wr_le32(&tx_msg.au8Data[4], data);

    CANFD_ClearStatusFlag(BRIDGE_CAN_PORT, CANFD_IR_TC_Msk | CANFD_IR_TCF_Msk);
    result = CANFD_TransmitTxMsg(BRIDGE_CAN_PORT, tx_slot, &tx_msg);
    return (result == 1u) ? 1u : 0u;
}

static void bridge_can_backend_handle_irq(bridge_can_backend_rx_push_fn rx_push)
{
    uint32_t status = CANFD_GetStatusFlag(BRIDGE_CAN_PORT,
                                          CANFD_IR_RF0N_Msk |
                                          CANFD_IR_RF0F_Msk |
                                          CANFD_IR_RF0L_Msk);

    if (status != 0u) {
        for (;;) {
            CANFD_FD_MSG_T rx_msg;
            uint32_t result = CANFD_ReadRxFifoMsg(BRIDGE_CAN_PORT, 0u, &rx_msg);
            if (result == 0u) {
                break;
            }
            if ((rx_push != NULL) && (rx_msg.u32DLC >= 8u)) {
                rx_push(bridge_can_backend_rd_le32(&rx_msg.au8Data[0]),
                        bridge_can_backend_rd_le32(&rx_msg.au8Data[4]));
            }
        }
        CANFD_ClearStatusFlag(BRIDGE_CAN_PORT, status);
    }
}

#endif


