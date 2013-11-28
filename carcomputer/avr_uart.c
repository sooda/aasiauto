#include <avr/interrupt.h>
#include "ringbufs.h"

ISR(USARTN_RXC_vect) {
	uartbuf_putchar(BUF_RXHOST, UDR);
}

ISR(USARTN_TXC_vect) {
	if (!uartbuf_empty(BUF_RXHOST))
		UDR = uartbuf_getchar(BUF_RXHOST);
}
