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

/* Actual onboard drive
 *
 * read physical state from the sensors, compute, drive the actuators
 */

// TODO: set this in a timer
volatile uint8_t flag_transmit;
volatile uint8_t flag_drive;

int main() {
	clock_prescale_set(clock_div_1);
	usart_init(38400);
	UCSR1B |= _BV(RXCIE1);
	UCSR1B |= _BV(TXCIE1);
	sei();
	DDRD |= _BV(6); // led
	DDRD |= _BV(3); // tx
	init();
	for (;;) {
		msgs_work();
		sensors_update();
		if (flag_drive)
			driveiter();
		if (flag_transmit)
			transmit_vals();
		PORTD ^= _BV(6);
	}
}
