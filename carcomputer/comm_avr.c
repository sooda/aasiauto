#include "comm.h"
#include "comm_avr.h"
#include "uartbuf.h"
#include <stdio.h>
#include <assert.h>
#include <string.h>

uint16_t comm_rxsize(void) {
	return ringbuf_size(BUF_RXHOST);
}

// these assume that the data exists already; if not, zero-filled
uint16_t comm_peek_u16(void) {
	uint16_t x = 0;
	ringbuf_peek(BUF_RXHOST, &x, sizeof(x));
	return x;
}

uint16_t comm_u16(void) {
	uint16_t x = 0;
	uartbuf_read(BUF_RXHOST, &x, sizeof(x));
	return x;
}
uint8_t comm_peek_u8(void) {
	uint8_t x = 0;
	ringbuf_peek(BUF_RXHOST, &x, sizeof(x));
	return x;
}

uint8_t comm_u8(void) {
	uint8_t x = 0;
	uartbuf_read(BUF_RXHOST, &x, sizeof(x));
	return x;
}

void dump_info(uint8_t stream, uint8_t type, uint8_t size, void *data) {
	//ringbuf_putchar(stream, 0xff);
	uartbuf_write(stream, &size, sizeof(size));
	uartbuf_write(stream, &type, sizeof(type));
	uartbuf_write(stream, data, size);
}

void comm_ignore(uint8_t nbytes) {
	uartbuf_read(BUF_RXHOST, NULL, nbytes);
}
