#include "ringbuf.h"

volatile uint8_t wptr[RBUF_NBUFS], rptr[RBUF_NBUFS];
uint8_t buffer[RBUF_NBUFS][RBUF_SIZE];

uint8_t ringbuf_write(uint8_t buf, void *ptr, uint8_t n) {
	uint8_t space = RBUF_SZMASK - ringbuf_size(buf);
	uint8_t wp = wptr[buf];
	if (space < n)
		n = space;
	if (wp + n - 1 <= RBUF_SZMASK) {
		memcpy(&buffer[buf][wp], ptr, n);
	} else {
		uint8_t end_fits = RBUF_SZMASK - wp + 1;
		memcpy(&buffer[buf][wp], ptr, end_fits);
		memcpy(&buffer[buf][0], ptr + end_fits, n - end_fits);
	}
	wptr[buf] = (wp + n) & RBUF_SZMASK;
	return n;
}

uint8_t ringbuf_peek(uint8_t buf, void *ptr, uint8_t n) {
	uint8_t used = ringbuf_size(buf);
	uint8_t rp = rptr[buf];
	if (used < n)
		n = used;
	if (ptr) {
		if (rp + n - 1 <= RBUF_SZMASK) {
			memcpy(ptr, &buffer[buf][rp], n);
		} else {
			uint8_t end_fits = RBUF_SZMASK - rp + 1;
			memcpy(ptr, &buffer[buf][rp], end_fits);
			memcpy(ptr + end_fits, &buffer[buf][0], n - end_fits);
		}
	}
	//rptr[buf] = (rp + n) & RBUF_SZMASK;
	return n;
}
uint8_t ringbuf_read(uint8_t buf, void *ptr, uint8_t n) {
	n = ringbuf_peek(buf, ptr, n);
	rptr[buf] = (rptr[buf] + n) & RBUF_SZMASK;
	return n;
}

void ringbuf_reset(void) {
	memset((void*)wptr, 0, sizeof(wptr));
	memset((void*)rptr, 0, sizeof(wptr));
}
