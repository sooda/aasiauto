#include "core.h"
#include "core_avr.h"
#include "uart.h"
#include "uart_stdio.h"
#include <avr/power.h>
#include <avr/interrupt.h>

#include <stdio.h>

MAKE_USART_INIT(0) // pc, or assert strings in emergency
MAKE_USART_INIT(1) // brakes
STDIO_SETUP(mystdout); // usart 0

int main() {
	stdio_setup(mystdout);
	clock_prescale_set(clock_div_1);
	usart_0_init(38400);
	usart_1_init(38400);
	init();
	avr_sched_init();
	board_init();
	sei();
	for (;;) {
		avr_iter();
	}
}
