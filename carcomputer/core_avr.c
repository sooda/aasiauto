#include "msgs.h"
#include "config.h"
#include "core_avr.h"
#include "core.h"
#include <avr/interrupt.h>
#include <avr/io.h>

volatile uint8_t flag_transmit; //  100 Hz
volatile uint8_t flag_drive;    // 1000 Hz

// 1000 Hz
ISR(TIMER0_COMPA_vect) {
	static uint8_t prescale;
	if (++prescale == TRANSMIT_PRESCALE) {
		prescale = 0;
		flag_transmit = 1;
	}
	flag_drive = 1;
}

void avr_sched_init(void) {
	// ripped from the original program
	
	// Clock source: System Clock
	// Clock value: 250,000 kHz
	// Mode: CTC top=OCR0A
	// OC0A output: Disconnected
	// OC0B output: Disconnected
	// Timer Period: 1 ms
	TCCR0A = (0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (1<<WGM01) | (0<<WGM00);
	TCCR0B = (0<<WGM02) | (0<<CS02) | (1<<CS01) | (1<<CS00);
	TCNT0 = 0x00;
	OCR0A = 0xF9;
	OCR0B = 0x00;
	//Enable timer compare interrupt
	TIMSK0 |= (1 << OCIE0A);
}

void avr_iter(void) {
	msgs_work(BUF_RXHOST);
	msgs_work(BUF_RXSLAVE);
	sensors_update();
	if (flag_drive) {
		flag_drive = 0;
		driveiter();
	}
	if (flag_transmit) {
		flag_transmit = 0;
		transmit();
	}
}

// too lazy to write even these to their own files
#if defined(MCU_ENCODERS)
void heartbeat(void) {
	PORTD ^= _BV(6);
}
void board_init(void) {
	DDRD |= _BV(3); // tx
	DDRD |= _BV(6); // heartbeat
}
#elif defined(MCU_DRIVER) || defined(MCU_BRAKES)
void heartbeat(void) {
	PORTA ^= _BV(2); // external blue led
	PORTB ^= _BV(7); // some internal foo
}
void board_init(void) {
	DDRD |= _BV(3); // tx
	DDRA |= 3; // brake/drive leds
	PORTA |= 3; // turn them on
	DDRA |= _BV(2); // ext blue
	DDRB |= _BV(7); // internal led
}
#endif
