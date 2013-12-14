#ifndef RINGBUF_H
#define RINGBUF_H

#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>

// so far, everything should be race-free because only uint8's

// get size from cfg
#include "config.h"

extern volatile uint8_t wptr[RBUF_NBUFS], rptr[RBUF_NBUFS];
extern uint8_t buffer[RBUF_NBUFS][RBUF_SIZE];

static inline uint8_t ringbuf_size(uint8_t buf) {
	return (wptr[buf] - rptr[buf]) & RBUF_SZMASK;
}

static inline uint8_t ringbuf_empty(uint8_t buf) {
	return wptr[buf] == rptr[buf];
}

// it's full when one item is unused!
static inline uint8_t ringbuf_full(uint8_t buf) {
	return ringbuf_size(buf) == RBUF_SZMASK;
}

// le ring side, byte at a time

// hw -> sw
// a macro makes it easier to catch the assertion at proper location
#if 0
static inline void ringbuf_putchar(uint8_t buf, uint8_t c) {
	assert(!ringbuf_full(buf));
	uint8_t wp = wptr[buf];
	buffer[buf][wp] = c;
	wptr[buf] = (wp + 1) & RBUF_SZMASK;
}
#else
#define ringbuf_putchar(buf, c) do { \
	assert(!ringbuf_full(buf)); \
	uint8_t wp = wptr[buf]; \
	buffer[buf][wp] = c; \
	wptr[buf] = (wp + 1) & RBUF_SZMASK; \
} while (0)
#endif

// sw -> hw
static inline uint8_t ringbuf_getchar(uint8_t buf) {
	assert(!ringbuf_empty(buf));
	uint8_t rp = rptr[buf];
	uint8_t c = buffer[buf][rp];
	rptr[buf] = (rp + 1) & RBUF_SZMASK;
	return c;
}

// user-side communication, bigger objects than a byte expected

uint8_t ringbuf_write(uint8_t buf, void *ptr, uint8_t n);
uint8_t ringbuf_peek(uint8_t buf, void *ptr, uint8_t n);
uint8_t ringbuf_read(uint8_t buf, void *ptr, uint8_t n);

void ringbuf_reset(void);

#endif
