#ifndef COMM_AVR_H
#define COMM_AVR_H

#if 0

#include "comm.h"
#include "ringbuf.h"
#include <stdio.h>
#include <assert.h>
#include <string.h>

static inline uint16_t comm_rxsize(void) {
	return hostbuf_size();
}

// these assume that the data exists already; if not, zero-filled
static inline uint16_t comm_peek_u16(void) {
	uint16_t x = 0;
	hostbuf_peek(&x, sizeof(x));
	return x;
}

static inline uint16_t comm_u16(void) {
	uint16_t x = 0;
	hostbuf_read(&x, sizeof(x));
	return x;
}

void dump_info(uint8_t stream, uint16_t type, uint16_t size, void *data);
#endif
#endif

