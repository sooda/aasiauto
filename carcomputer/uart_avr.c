#include <avr/interrupt.h>
#include <util/delay.h>
#include "ringbuf.h"

/* 0xff 0xff means data byte 0xff.
 * 0xff <something else> is a packet start signature,
 * and 0xff isn't actually there.
 */

// have to wait for a packet start at bootup.
// before that, can't pass bytes in.
static uint8_t in_sync;
// previous byte was ff
static uint8_t in_ff;

ISR(USART0_RX_vect) {
	uint8_t c = UDR0;
	if (in_sync) {
		if (in_ff) {
			in_ff = 0;
			// the first ff is skipped in the buf,
			// this character goes there anyhow
		} else if (c == 0xff) {
			in_ff = 1;
			return;
		}
	} else {
		if (in_ff) {
			in_ff = 0;
			if (c != 0xff) // not a data byte?
				in_sync = 1;
		} else if (c == 0xff) {
			in_ff = 1;
			return;
		}
	}
	ringbuf_putchar(BUF_RXHOST, c);
}

volatile uint8_t sending;

ISR(USART0_TX_vect) {
	if (!ringbuf_empty(BUF_TXHOST))
		UDR0 = ringbuf_getchar(BUF_TXHOST);
	else
		sending = 0;
}

void uartflush(void) {
	cli();
	if (!sending) {
		sending = 1;
		UDR0 = ringbuf_getchar(BUF_TXHOST);
	}
	sei();
}
