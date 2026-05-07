#ifndef BRIDGE_CAN_BACKEND_NUC131_H
#define BRIDGE_CAN_BACKEND_NUC131_H

static uint16_t s_bridge_can_backend_rx_filter_id;

static uint8_t bridge_can_backend_wait_if_ready(volatile CAN_IF_T *can_if)
{
    uint32_t budget = (SystemCoreClock / 1000u) + 200u;
    while ((can_if->CREQ & CAN_IF_CREQ_BUSY_Msk) != 0u) {
        if (budget == 0u) {
            return 0u;
        }
        budget--;
    }
    return 1u;
}

static uint8_t bridge_can_backend_wait_all_if_ready(void)
{
    if (!bridge_can_backend_wait_if_ready(&BRIDGE_CAN_PORT->IF[0])) {
        return 0u;
    }
    if (!bridge_can_backend_wait_if_ready(&BRIDGE_CAN_PORT->IF[1])) {
        return 0u;
    }
    return 1u;
}

static uint8_t bridge_can_backend_rx_msg_obj_from_slot(uint8_t rx_slot)
{
    if (rx_slot >= BRIDGE_CAN_RX_SLOT_COUNT) {
        rx_slot = 0u;
    }
    return (uint8_t)(BRIDGE_CAN_RX_MSG_OBJ_BASE + rx_slot);
}

static uint8_t bridge_can_backend_tx_msg_obj_from_slot(uint8_t tx_slot)
{
    if (tx_slot >= BRIDGE_CAN_TX_SLOT_COUNT) {
        tx_slot = 0u;
    }
    return (uint8_t)(BRIDGE_CAN_TX_MSG_OBJ_BASE + tx_slot);
}

static uint8_t bridge_can_backend_is_rx_msg_obj(uint8_t msg_obj)
{
    if (msg_obj < BRIDGE_CAN_RX_MSG_OBJ_BASE) {
        return 0u;
    }
    if (msg_obj >= (uint8_t)(BRIDGE_CAN_RX_MSG_OBJ_BASE + BRIDGE_CAN_RX_SLOT_COUNT)) {
        return 0u;
    }
    return 1u;
}

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

static uint8_t bridge_can_backend_invalidate_msg_obj(uint8_t msg_obj)
{
    volatile CAN_IF_T *can_if = &BRIDGE_CAN_PORT->IF[0];

    if (!bridge_can_backend_wait_if_ready(can_if)) {
        return 0u;
    }

    can_if->CMASK = CAN_IF_CMASK_WRRD_Msk |
                    CAN_IF_CMASK_MASK_Msk |
                    CAN_IF_CMASK_ARB_Msk |
                    CAN_IF_CMASK_CONTROL_Msk |
                    CAN_IF_CMASK_CLRINTPND_Msk |
                    CAN_IF_CMASK_TXRQSTNEWDAT_Msk |
                    CAN_IF_CMASK_DATAA_Msk |
                    CAN_IF_CMASK_DATAB_Msk;
    can_if->MASK1 = 0u;
    can_if->MASK2 = 0u;
    can_if->ARB1 = 0u;
    can_if->ARB2 = 0u;
    can_if->MCON = 0u;
    can_if->DAT_A1 = 0u;
    can_if->DAT_A2 = 0u;
    can_if->DAT_B1 = 0u;
    can_if->DAT_B2 = 0u;
    can_if->CREQ = (uint32_t)msg_obj + 1u;

    return bridge_can_backend_wait_if_ready(can_if);
}

static uint8_t bridge_can_backend_clear_int_pending_only(uint8_t msg_obj)
{
    volatile CAN_IF_T *can_if = &BRIDGE_CAN_PORT->IF[0];

    if (!bridge_can_backend_wait_if_ready(can_if)) {
        return 0u;
    }

    can_if->CMASK = CAN_IF_CMASK_WRRD_Msk |
                    CAN_IF_CMASK_CLRINTPND_Msk;
    can_if->CREQ = (uint32_t)msg_obj + 1u;

    return bridge_can_backend_wait_if_ready(can_if);
}

static uint8_t bridge_can_backend_prepare_tx_msg_obj(uint8_t msg_obj, uint16_t std_id, uint32_t cmd, uint32_t data)
{
    volatile CAN_IF_T *can_if = &BRIDGE_CAN_PORT->IF[0];
    uint8_t payload[8];

    if (!bridge_can_backend_wait_if_ready(can_if)) {
        return 0u;
    }

    bridge_can_backend_wr_le32(&payload[0], cmd);
    bridge_can_backend_wr_le32(&payload[4], data);

    can_if->CMASK = CAN_IF_CMASK_WRRD_Msk |
                    CAN_IF_CMASK_MASK_Msk |
                    CAN_IF_CMASK_ARB_Msk |
                    CAN_IF_CMASK_CONTROL_Msk |
                    CAN_IF_CMASK_DATAA_Msk |
                    CAN_IF_CMASK_DATAB_Msk;
    can_if->MASK1 = 0u;
    can_if->MASK2 = 0u;
    can_if->ARB1 = 0u;
    can_if->ARB2 = (((uint32_t)std_id & 0x7FFu) << 2) |
                   CAN_IF_ARB2_DIR_Msk |
                   CAN_IF_ARB2_MSGVAL_Msk;
    can_if->DAT_A1 = (uint16_t)(((uint16_t)payload[1] << 8) | payload[0]);
    can_if->DAT_A2 = (uint16_t)(((uint16_t)payload[3] << 8) | payload[2]);
    can_if->DAT_B1 = (uint16_t)(((uint16_t)payload[5] << 8) | payload[4]);
    can_if->DAT_B2 = (uint16_t)(((uint16_t)payload[7] << 8) | payload[6]);
    can_if->MCON = CAN_IF_MCON_NEWDAT_Msk | 8u | CAN_IF_MCON_EOB_Msk;
    can_if->CREQ = (uint32_t)msg_obj + 1u;

    return bridge_can_backend_wait_if_ready(can_if);
}

static uint8_t bridge_can_backend_trigger_tx_msg_obj(uint8_t msg_obj)
{
    volatile CAN_IF_T *can_if = &BRIDGE_CAN_PORT->IF[0];

    if (!bridge_can_backend_wait_if_ready(can_if)) {
        return 0u;
    }

    BRIDGE_CAN_PORT->STATUS &= ~CAN_STATUS_TXOK_Msk;

    can_if->CMASK = CAN_IF_CMASK_CLRINTPND_Msk |
                    CAN_IF_CMASK_TXRQSTNEWDAT_Msk;
    can_if->CREQ = (uint32_t)msg_obj + 1u;
    if (!bridge_can_backend_wait_if_ready(can_if)) {
        return 0u;
    }

    can_if->CMASK = CAN_IF_CMASK_WRRD_Msk |
                    CAN_IF_CMASK_TXRQSTNEWDAT_Msk;
    can_if->CREQ = (uint32_t)msg_obj + 1u;

    return bridge_can_backend_wait_if_ready(can_if);
}

extern int32_t CAN_SetRxMsgObj(CAN_T *tCAN, uint8_t u8MsgObj, uint8_t u8idType, uint32_t u32id, uint8_t u8singleOrFifoLast);
static uint8_t bridge_can_backend_configure_rx_fifo(uint16_t std_id)
{
    uint8_t i;

    if (BRIDGE_CAN_RX_SLOT_COUNT == 1u) {
        return (CAN_SetRxMsg(BRIDGE_CAN_PORT,
                             bridge_can_backend_rx_msg_obj_from_slot(0u),
                             CAN_STD_ID,
                             std_id) == TRUE) ? 1u : 0u;
    }

    for (i = 0u; i < BRIDGE_CAN_RX_SLOT_COUNT; i++) {
        uint8_t is_last = (i == (BRIDGE_CAN_RX_SLOT_COUNT - 1u)) ? TRUE : FALSE;
        if (CAN_SetRxMsgObj(BRIDGE_CAN_PORT,
                            bridge_can_backend_rx_msg_obj_from_slot(i),
                            CAN_STD_ID,
                            std_id,
                            is_last) == FALSE) {
            return 0u;
        }
    }
    return 1u;
}

static uint8_t bridge_can_backend_is_tx_pending(uint8_t msg_obj)
{
#if ((BRIDGE_CAN_TX_MSG_OBJ_BASE + BRIDGE_CAN_TX_SLOT_COUNT) <= 16u)
    return ((BRIDGE_CAN_PORT->TXREQ1 & (1ul << msg_obj)) != 0u) ? 1u : 0u;
#else
    if (msg_obj < 16u) {
        return ((BRIDGE_CAN_PORT->TXREQ1 & (1ul << msg_obj)) != 0u) ? 1u : 0u;
    }
    return ((BRIDGE_CAN_PORT->TXREQ2 & (1ul << (msg_obj - 16u))) != 0u) ? 1u : 0u;
#endif
}

static uint8_t bridge_can_backend_wait_tx_complete(uint8_t msg_obj)
{
    uint32_t budget = ((SystemCoreClock / 1000u) * BRIDGE_CAN_TX_HW_WAIT_MS) + 200u;
    while (bridge_can_backend_is_tx_pending(msg_obj) != 0u) {
        if (budget == 0u) {
            return 0u;
        }
        budget--;
    }
    return 1u;
}

extern void CAN_EnterInitMode(CAN_T *tCAN);
extern void CAN_LeaveInitMode(CAN_T *tCAN);

static void bridge_can_backend_force_abort_tx(void)
{
    uint8_t i;

    CAN_EnterInitMode(BRIDGE_CAN_PORT);
    for (i = 0u; i < BRIDGE_CAN_TX_SLOT_COUNT; i++) {
        (void)bridge_can_backend_invalidate_msg_obj(bridge_can_backend_tx_msg_obj_from_slot(i));
    }
    for (i = 0u; i < BRIDGE_CAN_RX_SLOT_COUNT; i++) {
        (void)bridge_can_backend_invalidate_msg_obj(bridge_can_backend_rx_msg_obj_from_slot(i));
    }
    CAN_LeaveInitMode(BRIDGE_CAN_PORT);
    (void)bridge_can_backend_configure_rx_fifo(s_bridge_can_backend_rx_filter_id);
}

static void bridge_can_backend_set_rx_filter(uint16_t rx_filter_id)
{
    s_bridge_can_backend_rx_filter_id = rx_filter_id;
}

static uint32_t bridge_can_backend_open(uint32_t bitrate)
{
    uint32_t actual_bitrate;

    actual_bitrate = CAN_Open(BRIDGE_CAN_PORT, bitrate, CAN_NORMAL_MODE);
    (void)bridge_can_backend_configure_rx_fifo(s_bridge_can_backend_rx_filter_id);
    CAN_EnableInt(BRIDGE_CAN_PORT, CAN_CON_IE_Msk | CAN_CON_SIE_Msk | CAN_CON_EIE_Msk);
    NVIC_SetPriority(BRIDGE_CAN_IRQn_ID, (1u << __NVIC_PRIO_BITS) - 2u);
    NVIC_EnableIRQ(BRIDGE_CAN_IRQn_ID);
    return actual_bitrate;
}

static void bridge_can_backend_stop(void)
{
    CAN_DisableInt(BRIDGE_CAN_PORT, CAN_CON_IE_Msk | CAN_CON_SIE_Msk | CAN_CON_EIE_Msk);
    NVIC_DisableIRQ(BRIDGE_CAN_IRQn_ID);
    SYS_UnlockReg();
    SYS_ResetModule(BRIDGE_CAN_RESET);
    SYS_LockReg();
}

static uint8_t bridge_can_backend_tx_cleanup_slot(uint8_t tx_slot)
{
    return bridge_can_backend_clear_int_pending_only(bridge_can_backend_tx_msg_obj_from_slot(tx_slot));
}

static uint8_t bridge_can_backend_send_slot(uint8_t tx_slot, uint16_t std_id, uint32_t cmd, uint32_t data)
{
    uint8_t tx_msg_obj = bridge_can_backend_tx_msg_obj_from_slot(tx_slot);

    if (!bridge_can_backend_wait_all_if_ready()) {
        return 0u;
    }
    if (bridge_can_backend_is_tx_pending(tx_msg_obj) != 0u) {
        if (!bridge_can_backend_wait_tx_complete(tx_msg_obj)) {
            bridge_can_backend_force_abort_tx();
            return 0u;
        }
    }

    if (!bridge_can_backend_prepare_tx_msg_obj(tx_msg_obj, std_id, cmd, data)) {
        return 0u;
    }
    if (!bridge_can_backend_trigger_tx_msg_obj(tx_msg_obj)) {
        return 0u;
    }
    if (!bridge_can_backend_wait_tx_complete(tx_msg_obj)) {
        bridge_can_backend_force_abort_tx();
        return 0u;
    }
    return 1u;
}

static void bridge_can_backend_handle_irq(bridge_can_backend_rx_push_fn rx_push)
{
    uint32_t iidr = CAN_GET_INT_PENDING_STATUS(BRIDGE_CAN_PORT);

    if (iidr == 0x00008000u) {
        if (BRIDGE_CAN_PORT->STATUS & CAN_STATUS_RXOK_Msk) {
            BRIDGE_CAN_PORT->STATUS &= ~CAN_STATUS_RXOK_Msk;
        }
        if (BRIDGE_CAN_PORT->STATUS & CAN_STATUS_TXOK_Msk) {
            BRIDGE_CAN_PORT->STATUS &= ~CAN_STATUS_TXOK_Msk;
        }
        return;
    }

    if (iidr != 0u) {
        uint8_t msg_obj = (uint8_t)(iidr - 1u);

        if (bridge_can_backend_is_rx_msg_obj(msg_obj) != 0u) {
            STR_CANMSG_T rx;
            if ((rx_push != NULL) && (CAN_Receive(BRIDGE_CAN_PORT, msg_obj, &rx) == TRUE)) {
                rx_push(bridge_can_backend_rd_le32((const uint8_t *)&rx.Data[0]),
                        bridge_can_backend_rd_le32((const uint8_t *)&rx.Data[4]));
            }
        } else {
            (void)bridge_can_backend_clear_int_pending_only(msg_obj);
        }
    }
}

#endif

