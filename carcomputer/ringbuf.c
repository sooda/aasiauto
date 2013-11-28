#include "ringbuf.h"

volatile uint8_t wptr[BUFS], rptr[BUFS];
uint8_t buffer[BUFS][SIZE];

uint8_t uartbuf_write(uint8_t buf, uint8_t *ptr, uint8_t n) {
	uint8_t space = SZMASK - uartbuf_size(buf);
	uint8_t wp = wptr[buf];
	if (space < n)
		n = space;
	if (wp + n - 1 <= SZMASK) {
		memcpy(&buffer[buf][wp], ptr, n);
	} else {
		uint8_t end_fits = SZMASK - wp + 1;
		memcpy(&buffer[buf][wp], ptr, end_fits);
		memcpy(&buffer[buf][0], ptr + end_fits, n - end_fits);
	}
	wptr[buf] = (wp + n) & SZMASK;
	return n;
}

uint8_t uartbuf_peek/*read*/(uint8_t buf, uint8_t *ptr, uint8_t n) {
	uint8_t used = uartbuf_size(buf);
	uint8_t rp = rptr[buf];
	if (used < n)
		n = used;
	if (ptr) {
		if (rp + n - 1 <= SZMASK) {
			memcpy(ptr, &buffer[buf][rp], n);
		} else {
			uint8_t end_fits = SZMASK - rp + 1;
			memcpy(ptr, &buffer[buf][rp], end_fits);
			memcpy(ptr + end_fits, &buffer[buf][0], n - end_fits);
		}
	}
	//rptr[buf] = (rp + n) & SZMASK;
	return n;
}
uint8_t uartbuf_read(uint8_t buf, uint8_t *ptr, uint8_t n) {
	n = uartbuf_peek(buf, ptr, n);
	rptr[buf] = (rptr[buf] + n) & SZMASK;
	return n;
}

void buf_reset(void) {
	memset((void*)wptr, 0, sizeof(wptr));
	memset((void*)rptr, 0, sizeof(wptr));
}
