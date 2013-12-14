#include "comm.h"
#include "uartbuf.h"
#include <stdio.h>
#include <assert.h>
#include <string.h>

uint8_t comm_rxsize(uint8_t buf) {
	return ringbuf_size(buf);
}

// these assume that the data exists already; if not, zero-filled
uint16_t comm_peek_u16(uint8_t buf) {
	uint16_t x = 0;
	ringbuf_peek(buf, &x, sizeof(x));
	return x;
}

uint16_t comm_u16(uint8_t buf) {
	uint16_t x = 0;
	uartbuf_read(buf, &x, sizeof(x));
	return x;
}
uint8_t comm_peek_u8(uint8_t buf) {
	uint8_t x = 0;
	ringbuf_peek(buf, &x, sizeof(x));
	return x;
}

uint8_t comm_u8(uint8_t buf) {
	uint8_t x = 0;
	uartbuf_read(buf, &x, sizeof(x));
	return x;
}

void dump_info(uint8_t stream, uint8_t type, uint8_t size, void *data) {
	// ringbuf_putchar(stream, 0xff);
	// how to sync things to pc host? maybe not needed if its buffers are big
	// enough; only slow handling has been proven to break the data stream
	uartbuf_write(stream, &size, sizeof(size));
	uartbuf_write(stream, &type, sizeof(type));
	uartbuf_write(stream, data, size);
}

void comm_ignore(uint8_t buf, uint8_t nbytes) {
	uartbuf_read(buf, NULL, nbytes);
}
