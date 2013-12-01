#ifndef RINGBUF_H
#define RINGBUF_H

#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>

// so far, everything should be race-free because only uint8's

// power of two, please
// bitmask and also index of last id
#define SZMASK 127 // TODO increase, this just for testing
#define SIZE (SZMASK+1)

#define BUFS 4
#define BUF_TXHOST 0 // to host
#define BUF_RXHOST 1 // from host
#define BUF_TXTEENSY 2
#define BUF_RXTEENSY 3

extern volatile uint8_t wptr[BUFS], rptr[BUFS];
extern uint8_t buffer[BUFS][SIZE];

static inline uint8_t ringbuf_size(uint8_t buf) {
	return (wptr[buf] - rptr[buf]) & SZMASK;
}

static inline uint8_t ringbuf_empty(uint8_t buf) {
	return wptr[buf] == rptr[buf];
}

static inline uint8_t ringbuf_full(uint8_t buf) {
	return ringbuf_size(buf) == SZMASK;
}

// le ring side, byte at a time

// hw -> sw
static inline void ringbuf_putchar(uint8_t buf, uint8_t c) {
	assert(!ringbuf_full(buf));
	uint8_t wp = wptr[buf];
	buffer[buf][wp] = c;
	wptr[buf] = (wp + 1) & SZMASK;
}

// sw -> hw
static inline uint8_t ringbuf_getchar(uint8_t buf) {
	assert(!ringbuf_empty(buf));
	uint8_t rp = rptr[buf];
	uint8_t c = buffer[buf][rp];
	rptr[buf] = (rp + 1) & SZMASK;
	return c;
}

// user-side communication, bigger objects than a byte expected

uint8_t ringbuf_write(uint8_t buf, void *ptr, uint8_t n);
uint8_t ringbuf_peek(uint8_t buf, void *ptr, uint8_t n);
uint8_t ringbuf_read(uint8_t buf, void *ptr, uint8_t n);

void ringbuf_reset(void);

#endif
