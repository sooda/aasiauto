#include "uart.h"
#include "msgs.h"
#include "core.h"
#include "ringbuf.h"
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <avr/power.h>

MAKE_USART_INIT(1) // brakes

volatile uint8_t flag_transmit; //  100 Hz
volatile uint8_t flag_drive;    // 1000 Hz

// 1000 Hz
ISR(TIMER0_COMPA_vect) {
	static uint8_t prescale;
#warning change 200 back to 10
	if (++prescale == 200) {
		prescale = 0;
		flag_transmit = 1;
	}
	flag_drive = 1;
}

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

int main() {
	clock_prescale_set(clock_div_1);
	usart_1_init(38400);
	// assert(!"testing");
	DDRD |= _BV(3); // tx
	// leds
	DDRD |= _BV(6);
	worktimer_init();
	init();
	sei();
	for (;;) {
		msgs_work(BUF_RXHOST);
		sensors_update();
		if (flag_drive) {
			flag_drive = 0;
			//driveiter();
		}
		if (flag_transmit) {
			flag_transmit = 0;
			transmit_vals();
			PORTD ^= _BV(6);
		}
	}
}

