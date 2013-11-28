#ifndef RINGBUF_H
#define RINGBUF_H

#include <stdint.h>
#include <string.h>
#include <assert.h>

// so far, everything should be race-free because only uint8's

// power of two, please
// bitmask and also index of last id
#define SZMASK 7 // TODO increase, this just for testing
#define SIZE (SZMASK+1)

#define BUFS 4
#define BUF_TXHOST 0 // to host
#define BUF_RXHOST 1 // from host
#define BUF_TXTEENSY 2
#define BUF_RXTEENSY 3

extern volatile uint8_t wptr[BUFS], rptr[BUFS];
extern uint8_t buffer[BUFS][SIZE];

static inline uint8_t uartbuf_size(uint8_t buf) {
	return (wptr[buf] - rptr[buf]) & SZMASK;
}

static inline uint8_t uartbuf_empty(uint8_t buf) {
	return wptr[buf] == rptr[buf];
}

static inline uint8_t uartbuf_full(uint8_t buf) {
	return uartbuf_size(buf) == SZMASK;
}

// le uart side, byte at a time

// hw -> sw
static inline void uartbuf_putchar(uint8_t buf, uint8_t c) {
	assert(!uartbuf_full(buf));
	uint8_t wp = wptr[buf];
	buffer[buf][wp] = c;
	wptr[buf] = (wp + 1) & SZMASK;
}

// sw -> hw
static inline uint8_t uartbuf_getchar(uint8_t buf) {
	assert(!uartbuf_empty(buf));
	uint8_t rp = rptr[buf];
	uint8_t c = buffer[buf][rp];
	rptr[buf] = (rp + 1) & SZMASK;
	return c;
}

// user-side communication, bigger objects than a byte expected

uint8_t uartbuf_write(uint8_t buf, uint8_t *ptr, uint8_t n);
uint8_t uartbuf_peek/*read*/(uint8_t buf, uint8_t *ptr, uint8_t n);
uint8_t uartbuf_read(uint8_t buf, uint8_t *ptr, uint8_t n);

static inline uint8_t hostbuf_write(void *ptr, uint8_t n) {
	return uartbuf_write(BUF_TXHOST, ptr, n);
}
static inline uint8_t hostbuf_read(void *ptr, uint8_t n) {
	return uartbuf_read(BUF_RXHOST, ptr, n);
}
static inline uint8_t hostbuf_peek(void *ptr, uint8_t n) {
	return uartbuf_peek(BUF_RXHOST, ptr, n);
}
static inline uint8_t hostbuf_size(void) {
	return uartbuf_size(BUF_RXHOST);
}

void buf_reset(void);

#endif
