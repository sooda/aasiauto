#include "uartbuf.h"
#include "uart.h"

void uartbuf_write(uint8_t buf, void *ptr, uint8_t n) {
	while (n) {
		uint8_t sent = ringbuf_write(buf, ptr, n);
		uartflush(buf);
		n -= sent;
		ptr += sent;
	}
}
void uartbuf_read(uint8_t buf, void *ptr, uint8_t n) {
	while (n) {
		uint8_t recvd = ringbuf_read(buf, ptr, n);
		n -= recvd;
		if (ptr) // OK to be null; data ignored
			ptr += recvd;
	}
}

void buf_reset(void);
