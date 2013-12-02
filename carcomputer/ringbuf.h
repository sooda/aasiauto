#ifndef RINGBUF_H
#define RINGBUF_H

#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>

// so far, everything should be race-free because only uint8's

// power of two, please
// bitmask and also index of last id
#define SZMASK 255
#define SIZE (SZMASK+1)

#define BUFS 4
#define BUF_TXHOST 0 // to host
#define BUF_RXHOST 1 // from host
// drive controller talks to brakes, brakes talk to teensy
// (TODO teensy doesn't talk to anybody; tune these in config.h)
#define BUF_TXSLAVE 2
#define BUF_RXSLAVE 3

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
// a macro makes it easier to catch the assertion at proper location
#if 0
static inline void ringbuf_putchar(uint8_t buf, uint8_t c) {
	assert(!ringbuf_full(buf));
	uint8_t wp = wptr[buf];
	buffer[buf][wp] = c;
	wptr[buf] = (wp + 1) & SZMASK;
}
#else
#define ringbuf_putchar(buf, c) do { \
	assert(!ringbuf_full(buf)); \
	uint8_t wp = wptr[buf]; \
	buffer[buf][wp] = c; \
	wptr[buf] = (wp + 1) & SZMASK; \
} while (0)
#endif

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
