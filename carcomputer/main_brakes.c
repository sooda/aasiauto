#include "core.h"
#include "core_avr.h"
#include "uart.h"
#include "uart_stdio.h"
#include <avr/power.h>
#include <avr/interrupt.h>

MAKE_USART_INIT(0) // pc, if debugging
MAKE_USART_INIT(1) // driver
MAKE_USART_INIT(3) // teensy
STDIO_SETUP(mystdout); // usart 0

int main() {
	stdio_setup(mystdout);
	clock_prescale_set(clock_div_1);
	usart_0_init(38400);
	UCSR0B &= ~(_BV(RXCIE0) | _BV(TXCIE0)); // thanks init, but not for me
	printf("Hello world"); // cli() in putchar won't affect yet here
	usart_1_init(38400);
	usart_3_init(38400);
	init();
	avr_sched_init();
	board_init();
	sei();
	for (;;) {
		avr_iter();
	}
}
