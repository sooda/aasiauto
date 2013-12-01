#include "pwm.h"
#include <avr/io.h>
#include <stdlib.h>
#include <assert.h>
#include "comm.h"

void pwm_set(uint8_t i, uint16_t pos) {
	// TODO map these properly
	switch (i) {
		case 0: OCR1A = pos; break;
		case 1: OCR1B = pos; break;
		case 2: OCR3A = pos; break;
		case 3: OCR3B = pos; break;
		default: assert(0); break;
	}
	PORTA |= 0B00000011;
}

// both main and brake arduinos use the same configs for servo pwm
void pwm_init_main_brakes(void) {
	PORTA |= 0B00000011;
	DDRE |= _BV(3); // oc3a steer
	DDRB |= _BV(5); // oc1a left
	DDRB |= _BV(6); // oc1b right
	// clear OCn pin on compare match
	// wave generation mode PWM phase & freq correct, top at ICR
	// clock source clkio/8
	// 16e6/(2*8*20000) = 50 Hz

	TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (0<<COM1B0) | (0<<COM1C1) | (0<<COM1C0) | (0<<WGM11) | (0<<WGM10);
	TCCR1B=(0<<ICNC1) | (0<<ICES1) | (1<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
	TCNT1H=0x00;
	TCNT1L=0x00;
	ICR1H=0x4E; // 20000
	ICR1L=0x20;
	OCR1AH=0x05; // 1500
	OCR1AL=0xDC;
	OCR1BH=0x05; // 1500
	OCR1BL=0xDC;
	OCR1CH=0x00;
	OCR1CL=0x00;

	TCCR3A=(1<<COM3A1) | (0<<COM3A0) | (1<<COM3B1) | (0<<COM3B0) | (0<<COM3C1) | (0<<COM3C0) | (0<<WGM31) | (0<<WGM30);
	TCCR3B=(0<<ICNC3) | (0<<ICES3) | (1<<WGM33) | (0<<WGM32) | (0<<CS32) | (1<<CS31) | (0<<CS30);
	TCNT3H=0x00;
	TCNT3L=0x00;
	ICR3H=0x4E;
	ICR3L=0x20;
	OCR3AH=0x05;
	OCR3AL=0xDC;
	OCR3BH=0x05;
	OCR3BL=0xDC;
	OCR3CH=0x00;
	OCR3CL=0x00;

	/* original control:
	OCR1A = 1500 + (2 - 4 * driving_direction) * throttle + (steering_direction - 128) * throttle / 200;
	OCR1B = 1500 + (2 - 4 * driving_direction) * throttle - (steering_direction - 128) * throttle / 200; 
	OCR3A = 1200 + 2.9 * steering_direction;
	*/
}

void pwm_init(void) {
#if defined(MCU_MAIN) || defined(MCU_BRAKES)
	pwm_init_main_brakes();
#else
#error not yet
#endif
}
