#ifndef COMM_H
#define COMM_H

#include <stdint.h>
#include "ringbuf.h"
#include "uartbuf.h"

void dump_info(uint8_t stream, uint8_t type, uint8_t size, void *data);

#define DUMP_INFO(type, data) dump_info(BUF_TXHOST, type, sizeof(data), &data)

// relay data from buffer to another; useful for pings and brake parameters
#define COMM_PROXY(from, to, msgid, data) do { \
	uartbuf_read(from, &data, sizeof(data)); \
	dump_info(to, msgid, sizeof(data), &data); \
} while (0)

#include "protocol.h"

uint8_t comm_rxsize(uint8_t buf);
uint16_t comm_peek_u16(uint8_t buf);
uint16_t comm_u16(uint8_t buf);
uint8_t comm_peek_u8(uint8_t buf);
uint8_t comm_u8(uint8_t buf);
void comm_ignore(uint8_t buf, uint8_t nbytes);
void comm_error(uint16_t errnr, uint16_t param);

#endif
