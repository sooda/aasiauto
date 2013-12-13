#include <avr/interrupt.h>
#include <util/delay.h>
#include "ringbuf.h"
#include "config.h"

// sync when starting a new message when there isn't another going already
volatile uint8_t sending;
#define HOST_BIT 0
#define SLAVE_BIT 1

// FIXME use UART_HOST, UART_SLAVE
// FIXME more macro magic

#ifdef MCU_DRIVER
/* 0xff 0xff means data byte 0xff.
 * 0xff <something else> is a packet start signature,
 * and 0xff isn't actually there.
 */

// have to wait for a packet start at bootup.
// before that, can't pass bytes in.
static uint8_t in_sync;
// previous byte was ff
static uint8_t in_ff;

// ping timeout -> do this
void uarthost_desync(void) {
	cli();
	in_sync = 0;
	in_ff = 0;
	sei();
}

// only the drive controller uses usart 0
// it's a special case, needs this sync shit
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

ISR(USART0_TX_vect) {
	if (!ringbuf_empty(BUF_TXHOST))
		UDR0 = ringbuf_getchar(BUF_TXHOST);
	else
		sending &= ~_BV(HOST_BIT);
}

ISR(USART1_RX_vect) {
	ringbuf_putchar(BUF_RXSLAVE, UDR1);
}

ISR(USART1_TX_vect) {
	if (!ringbuf_empty(BUF_TXSLAVE))
		UDR1 = ringbuf_getchar(BUF_TXSLAVE);
	else
		sending &= ~_BV(SLAVE_BIT);
}
#endif

#ifdef MCU_BRAKES
ISR(USART1_RX_vect) {
	ringbuf_putchar(BUF_RXHOST, UDR1);
}
ISR(USART1_TX_vect) {
	if (!ringbuf_empty(BUF_TXHOST))
		UDR1 = ringbuf_getchar(BUF_TXHOST);
	else
		sending &= ~_BV(HOST_BIT);
}

ISR(USART3_RX_vect) {
	ringbuf_putchar(BUF_RXSLAVE, UDR3);
}
ISR(USART3_TX_vect) {
	if (!ringbuf_empty(BUF_TXSLAVE))
		UDR3 = ringbuf_getchar(BUF_TXSLAVE);
	else
		sending &= ~_BV(SLAVE_BIT);
}
#endif

#ifdef MCU_ENCODERS
ISR(USART1_RX_vect) {
	ringbuf_putchar(BUF_RXHOST, UDR1);
}
ISR(USART1_TX_vect) {
	if (!ringbuf_empty(BUF_TXHOST))
		UDR1 = ringbuf_getchar(BUF_TXHOST);
	else
		sending &= ~_BV(HOST_BIT);
}
#endif

void uartflush_host(void) {
	cli();
	if (!(sending & _BV(HOST_BIT))) {
		sending |= _BV(HOST_BIT);
		UDRNUM(UART_HOST) = ringbuf_getchar(BUF_TXHOST);
	}
	sei();
}

#ifdef UART_SLAVE

void uartflush_slave(void) {
	cli();
	if (!(sending & _BV(SLAVE_BIT))) {
		sending |= _BV(SLAVE_BIT);
		UDRNUM(UART_SLAVE) = ringbuf_getchar(BUF_TXSLAVE);
	}
	sei();
}

#else

// won't get here, but needs to compile (FIXME)
void uartflush_slave(void) {
}

#endif
