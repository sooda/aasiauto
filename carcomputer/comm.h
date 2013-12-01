#ifndef COMM_H
#define COMM_H

#include <stdint.h>
#include "ringbuf.h"

void dump_info(uint8_t stream, uint16_t type, uint16_t size, void *data);
void recv_info(uint8_t stream, uint16_t *type, uint16_t *size, void *data);
void recv_info_check(uint8_t stream, uint16_t type, uint16_t size, void *data);

#define DUMP_INFO(type, data) dump_info(BUF_TXHOST, type, sizeof(data), &data)

// TODO populate the original list here
#define MSG_PING 0
#define MSG_PONG 1
#define MSG_THROTTLE 2
#define ENCODERS_STATE 3
#define MSG_ERR 4
#define MSG_STEER 5

uint16_t comm_rxsize(void);
uint16_t comm_peek_u16(void);
uint16_t comm_u16(void);
void comm_ignore(uint8_t nbytes);
void comm_error(uint16_t errnr);

#endif
