/***************************************************************************//**
 * @file     main.c
 * @brief    ISP tool main function
 * @version  0x34
 * @date     14, June, 2017
 *
 * @note
 * SPDX-License-Identifier: Apache-2.0
 * Copyright (C) 2017-2018 Nuvoton Technology Corp. All rights reserved.
 ******************************************************************************/
//#include <stdio.h>
#include <string.h>
#include "NuMicro.h"
#include "fmc_user.h"

#define CAN_BAUD_RATE                     500000
#define Master_ISP_ID                     0x487
#define Device0_ISP_ID                    0x784
#define CAN_ISP_DtatLength                0x08
#define TRACE_BAUD_RATE                   115200

#define CMD_READ_CONFIG                   0xA2000000
#define CMD_RUN_APROM                     0xAB000000
#define CMD_GET_DEVICEID                  0xB1000000

/*---------------------------------------------------------------------------*/
/*  Function Declare                                                         */
/*---------------------------------------------------------------------------*/

/* Declare a CAN message structure */
STR_CANMSG_T rrMsg;
volatile uint8_t u8CAN_PackageFlag = 0;

static void TRACE_Init(void)
{
    CLK->APBCLK0 |= CLK_APBCLK0_UART0CKEN_Msk;
    CLK->CLKSEL1 = (CLK->CLKSEL1 & (~CLK_CLKSEL1_UART0SEL_Msk)) | CLK_CLKSEL1_UART0SEL_HIRC;
    CLK->CLKDIV0 = (CLK->CLKDIV0 & (~CLK_CLKDIV0_UART0DIV_Msk)) | CLK_CLKDIV0_UART0(1);
    SYS->IPRST1 |= SYS_IPRST1_UART0RST_Msk;
    SYS->IPRST1 &= ~SYS_IPRST1_UART0RST_Msk;
    UART0->FUNCSEL = UART_FUNCSEL_UART;
    UART0->LINE = UART_WORD_LEN_8 | UART_PARITY_NONE | UART_STOP_BIT_1;
    UART0->BAUD = UART_BAUD_MODE2 | UART_BAUD_MODE2_DIVIDER(__HIRC, TRACE_BAUD_RATE);
    UART0->FIFO = UART_FIFO_RXRST_Msk | UART_FIFO_TXRST_Msk;
}

static void TRACE_PutChar(char ch)
{
    while (UART0->FIFOSTS & UART_FIFOSTS_TXFULL_Msk)
    {
    }

    UART0->DAT = (uint32_t)ch;
}


/*---------------------------------------------------------------------------------------------------------*/
/* CAN interrupt handler                                                                                   */
/*---------------------------------------------------------------------------------------------------------*/
void CAN0_IRQHandler(void)
{
}

void SYS_Init(void)
{
    /*---------------------------------------------------------------------------------------------------------*/
    /* Init System Clock                                                                                       */
    /*---------------------------------------------------------------------------------------------------------*/
    /* Unlock protected registers */
    SYS_UnlockReg();

    /* Enable HIRC clock (Internal RC 48MHz) */
    CLK->PWRCTL |= CLK_PWRCTL_HIRCEN_Msk;

    /* Wait for HIRC clock ready */
    while ((CLK->STATUS & CLK_STATUS_HIRCSTB_Msk) != CLK_STATUS_HIRCSTB_Msk);

    /* Select HCLK clock source as HIRC and HCLK source divider as 1 */
    CLK->CLKSEL0 = (CLK->CLKSEL0 & (~CLK_CLKSEL0_HCLKSEL_Msk)) | CLK_CLKSEL0_HCLKSEL_HIRC;
    CLK->CLKDIV0 = (CLK->CLKDIV0 & (~CLK_CLKDIV0_HCLKDIV_Msk)) | CLK_CLKDIV0_HCLK(1);
    CLK->PCLKDIV = (CLK->PCLKDIV & ~(CLK_PCLKDIV_APB0DIV_Msk | CLK_PCLKDIV_APB1DIV_Msk)) |
                   CLK_PCLKDIV_APB0DIV_DIV1 | CLK_PCLKDIV_APB1DIV_DIV1;

    /* Enable CAN0 module clock */
    CLK->APBCLK0 |= CLK_APBCLK0_CAN0CKEN_Msk;

    /* Update System Core Clock */
    SystemCoreClock = __HIRC;
    CyclesPerUs = (SystemCoreClock + 500000) / 1000000;

    /*---------------------------------------------------------------------------------------------------------*/
    /* Init I/O Multi-function                                                                                 */
    /*---------------------------------------------------------------------------------------------------------*/
    /* Set PB multi-function pins for CAN0 TXD(PB.7) and RXD(PB.5) */
    SYS->GPB_MFP1 = (SYS->GPB_MFP1 & ~(SYS_GPB_MFP1_PB4MFP_Msk | SYS_GPB_MFP1_PB5MFP_Msk |
                                       SYS_GPB_MFP1_PB6MFP_Msk | SYS_GPB_MFP1_PB7MFP_Msk)) |
                    (SYS_GPB_MFP1_PB4MFP_UART0_TXD | SYS_GPB_MFP1_PB5MFP_CAN0_RXD |
                     SYS_GPB_MFP1_PB6MFP_UART0_RXD | SYS_GPB_MFP1_PB7MFP_CAN0_TXD);

    /* Lock protected registers */
    SYS_LockReg();
}

/*----------------------------------------------------------------------------*/
/*  Tx Msg by Normal Mode Function (With Message RAM)                         */
/*----------------------------------------------------------------------------*/
void CAN_Package_ACK(CAN_T *tCAN)
{
    STR_CANMSG_T tMsg;

    /* Send a 11-bit Standard Identifier message */
    tMsg.FrameType = CAN_DATA_FRAME;
    tMsg.IdType    = CAN_STD_ID;
    tMsg.Id        = Device0_ISP_ID;
    tMsg.DLC       = CAN_ISP_DtatLength;
    memcpy(&tMsg.Data, &rrMsg.Data, 8);

    if (CAN_Transmit(tCAN, MSG(5), &tMsg) == FALSE)   /* Configure Msg RAM and send the Msg in the RAM */
    {
        return;
    }

    while (tCAN->TXREQ1 & (1UL << MSG(5)))
    {
    }
}

void CAN_Init(void)
{
    SYS->IPRST1 |= SYS_IPRST1_CAN0RST_Msk;
    SYS->IPRST1 &= ~SYS_IPRST1_CAN0RST_Msk;

    /* Set CAN target baud-rate 500KHz with PCLK0 = 48MHz */
    CAN_EnterInitMode(CAN, (uint8_t)0);
    CAN->BTIME = 0x1C45;
    CAN_LeaveInitMode(CAN);

    /* Set CAN reveive message */
    CAN_SetRxMsg(CAN, MSG(0), CAN_STD_ID, Master_ISP_ID);
}

int main(void)
{
    uint32_t    Address, Data, u32Tmp;

    /* Init System, IP clock and multi-function I/O */
    SYS_Init();
    TRACE_Init();
    TRACE_PutChar('S');

    /* Unlock protected registers */
    SYS_UnlockReg();

   /* Enable FMC ISP function. Before using FMC function, it should unlock system register first. */
    FMC->ISPCTL |=  FMC_ISPCTL_ISPEN_Msk;

    FMC_ENABLE_AP_UPDATE();
    FMC_ENABLE_CFG_UPDATE();
    CAN_Init();

    /* stat update program */
    while (1)
    {
        if (CAN_GET_NEW_DATA_IN_BIT(CAN, MSG(0)))
        {
            CAN_Receive(CAN, 0, &rrMsg);
            u8CAN_PackageFlag = 1;
            TRACE_PutChar('R');
        }

        if (u8CAN_PackageFlag)
        {
            u8CAN_PackageFlag = 0;
            memcpy(&Address, &rrMsg.Data[0], 4);
            memcpy(&Data, &rrMsg.Data[4], 4);

            if (Address == CMD_GET_DEVICEID)
            {
                u32Tmp = SYS->PDID;
                memcpy(&rrMsg.Data[4], &u32Tmp, 4);
                TRACE_PutChar('D');
            }
            else if (Address == CMD_READ_CONFIG)
            {
                ReadData(Data, Data + 4, &u32Tmp);
                memcpy(&rrMsg.Data[4], &u32Tmp, 4);
            }
            else if (Address == CMD_RUN_APROM)
            {
                continue;
            }
            else
            {
                if ((Address & (FMC_FLASH_PAGE_SIZE - 1U)) == 0U)
                {
                    FMC_Erase_User(Address);
                }

                WriteData(Address, Address + 4, &Data);         /* program ROM */
                ReadData(Address, Address + 4, &Data);
                memcpy(&rrMsg.Data[4], &Data, 4); /* update data */
            }

            TRACE_PutChar('A');
            CAN_Package_ACK(CAN);            /* send CAN ISP Package (ACK) */
        }
    }
}
