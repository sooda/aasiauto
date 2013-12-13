#ifndef COMM_H
#define COMM_H

#include <stdint.h>
// FIXME BUF_TXHOST into config etc
#include "ringbuf.h"
#include "uartbuf.h"

void dump_info(uint8_t stream, uint8_t type, uint8_t size, void *data);
void recv_info(uint8_t stream, uint8_t *type, uint8_t *size, void *data);
void recv_info_check(uint8_t stream, uint8_t type, uint8_t size, void *data);

#define DUMP_INFO(type, data) dump_info(BUF_TXHOST, type, sizeof(data), &data)

// relay data from buffer to another; useful for pings and brake parameters
#define COMM_PROXY(from, to, msgid, data) do { \
	uartbuf_read(from, &data, sizeof(data)); \
	dump_info(to, msgid, sizeof(data), &data); \
} while (0)

// protocol desc
#define MSG_PING 0
#define MSG_PONG 1
#define MSG_REQ_PARAMS 2
#define MSG_REQ_PARAMS_FROM_HOST_WHATS_THIS 3
#define MSG_ERR 4
#define MSG_BRAKE_PARAMS_START 10
#define MSG_BRAKE_PARAMS_END 17
#define MSG_ABS_PARAMS_START 20
#define MSG_ABS_PARAMS_END 35
#define MSG_ESP_PARAMS_START 40
#define MSG_ESP_PARAMS_END 56
#define MSG_PARAMS_EOF 99
#define MSG_CAR_MEAS_VECTOR 110
#define MSG_THROTTLE 120
#define MSG_STEER 121
#define MSG_BRAKE 122
#define MSG_HORN 123

#define MEAS_NITEMS 13 // number of scalar elements

#define MSG_HDRSIZE 2

uint8_t comm_rxsize(uint8_t buf);
uint16_t comm_peek_u16(uint8_t buf);
uint16_t comm_u16(uint8_t buf);
uint8_t comm_peek_u8(uint8_t buf);
uint8_t comm_u8(uint8_t buf);
void comm_ignore(uint8_t buf, uint8_t nbytes);
void comm_error(uint16_t errnr, uint16_t param);

#endif
