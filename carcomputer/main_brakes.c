#include "comm_avr.h"
#include "comm.h"
#include "uartbuf.h"
#include "core.h"
#include "msgs.h"
#include <stdint.h>
#include <string.h>
#include <avr/power.h>
#include "uart.h"
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <stdio.h>

MAKE_USART_INIT(0) // pc, if debugging
MAKE_USART_INIT(1) // driver
MAKE_USART_INIT(3) // teensy

/* Actual onboard drive
 *
 * read physical state from the sensors, compute, drive the actuators
 */

volatile uint8_t flag_transmit; //  100 Hz
volatile uint8_t flag_drive;    // 1000 Hz

// 1000 Hz
ISR(TIMER0_COMPA_vect) {
	static uint8_t prescale;
#warning 200 vs 10
	if (++prescale == 50) {
		prescale = 0;
		flag_transmit = 1;
	}
	flag_drive = 1;
}

static int uart_putchar(char c, FILE *stream) {
	(void)stream;
	cli();
	while (!(UCSR0A & _BV(UDRE0)))
		;
	UDR0 = c;
	while (!(UCSR0A & _BV(UDRE0)))
		;
	//sei();
	return 0;
}
static FILE mystdout = FDEV_SETUP_STREAM(uart_putchar, NULL, _FDEV_SETUP_WRITE);


void worktimer_init(void) {
	// ripped from the original program
	
	// Timer/Counter 0 initialization
	// Clock source: System Clock
	// Clock value: 250,000 kHz
	// Mode: CTC top=OCR0A
	// OC0A output: Disconnected
	// OC0B output: Disconnected
	// Timer Period: 1 ms
	TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (1<<WGM01) | (0<<WGM00);
	TCCR0B=(0<<WGM02) | (0<<CS02) | (1<<CS01) | (1<<CS00);
	TCNT0=0x00;
	OCR0A=0xF9;
	OCR0B=0x00;
	//Enable timer compare interrupt
	TIMSK0 |= (1 << OCIE0A);
}

int initd;

int main() {
#if 0
	DDRA |= _BV(2);
	DDRB |= _BV(7);
	for(;;) {
		PORTA ^= _BV(2);
		PORTA ^= _BV(7);
		_delay_ms(1000);
	}
#endif
	stdout = &mystdout;
	stderr = &mystdout;
	clock_prescale_set(clock_div_1);
	usart_0_init(38400);
	UCSR0B &= ~(_BV(RXCIE0) | _BV(TXCIE0));
	printf("Hello world"); // cli() in putchar won't affect yet here
	printf("Wollo Hello world"); // cli() in putchar won't affect yet here
	usart_1_init(38400);
	usart_3_init(38400);
	//DDRD |= _BV(6); // led
	DDRD |= _BV(3); // tx
	DDRA |= 3;
	// leds
	DDRA |= _BV(2);
	DDRB |= _BV(7);
	worktimer_init();
	init();
	sei();
	for (;;) {
		msgs_work(BUF_RXHOST);
		msgs_work(BUF_RXSLAVE);
		sensors_update();
		if (flag_drive) {
			flag_drive = 0;
			driveiter();
		}
		if (flag_transmit) {
			flag_transmit = 0;
			//if (initd) { initd = 0;
			//	transmit_vals(); }
			transmit_vals();
			PORTA ^= _BV(2);
			PORTB ^= _BV(7);
		}
	}
}

