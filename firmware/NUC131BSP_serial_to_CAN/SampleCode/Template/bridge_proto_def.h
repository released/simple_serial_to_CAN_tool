#ifndef BRIDGE_PROTO_DEF_H
#define BRIDGE_PROTO_DEF_H

#include <stdint.h>

#define FRAME_SOF0                      (0x55u)
#define FRAME_SOF1                      (0xAAu)
#define FRAME_VERSION                   (0x01u)

#define FRAME_TYPE_REQUEST              (0x10u)
#define FRAME_TYPE_RESPONSE             (0x20u)

#define CMD_PING                        (0x01u)
#define CMD_SET_CAN_BITRATE             (0x10u)
#define CMD_ENTER_BOOTLOADER            (0x20u)
#define CMD_ERASE                       (0x21u)
#define CMD_PROGRAM_BEGIN               (0x22u)
#define CMD_PROGRAM_BLOCK               (0x23u)
#define CMD_PROGRAM_END                 (0x24u)
#define CMD_VERIFY                      (0x25u)
#define CMD_RUN                         (0x26u)
#define CMD_VERIFY_READBACK_BLOCK       (0x27u)

/* NuvoISP / NuLink2 ISP host style commands */
#define CMD_ISP_GET_VERSION             (0x30u)
#define CMD_ISP_CONNECT                 (0x31u)
#define CMD_ISP_SYNC_PACKNO             (0x32u)
#define CMD_ISP_GET_DEVICEID            (0x33u)
#define CMD_ISP_READ_CONFIG             (0x34u)
#define CMD_ISP_UPDATE_CONFIG           (0x35u)
#define CMD_ISP_UPDATE_APROM_WORD       (0x36u)
#define CMD_ISP_UPDATE_DATAFLASH_WORD   (0x37u)
#define CMD_ISP_ERASE_ALL               (0x38u)
#define CMD_ISP_RUN_APROM               (0x39u)
#define CMD_ISP_RUN_LDROM               (0x3Au)
#define CMD_ISP_RESET                   (0x3Bu)
#define CMD_ISP_RESEND_PACKET           (0x3Cu)
#define CMD_ISP_ERASE_SPIFLASH          (0x3Du)
#define CMD_ISP_UPDATE_SPIFLASH_WORD    (0x3Eu)
#define CMD_ISP_CAN_GET_DEVICEID        (0x3Fu)
#define CMD_ISP_CAN_READ_CONFIG         (0x40u)
#define CMD_ISP_CAN_RUN_APROM           (0x41u)
#define CMD_ISP_RAW32                   (0x42u)

#define STATUS_OK                       (0x00u)
#define STATUS_BUSY                     (0x01u)
#define STATUS_BAD_COMMAND              (0x02u)
#define STATUS_BAD_ARGUMENT             (0x03u)
#define STATUS_CRC_ERROR                (0x04u)
#define STATUS_SEQUENCE_ERROR           (0x05u)
#define STATUS_VERIFY_FAILED            (0x06u)
#define STATUS_TIMEOUT                  (0x07u)
#define STATUS_INTERNAL_ERROR           (0x08u)

#endif
