#include "uart.h"
#include "core.h"
#include "core_avr.h"
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/power.h>

// <meas copypasta start> FIXME: should abstract these away
#include "initTeensy.h"
#include "wheelSpeeds.h"

typedef struct {
    unsigned char intFlag;
    unsigned int Cnt;
} cycleData_t;

static cycleData_t cycleData;

void prgm100Hz(void);
void prgm800Hz(void);

void measinit(void) {
	cycleData.intFlag = 0;
	cycleData.Cnt = 0;
	initWheelData();
	initPorts();
	initTimers();
	initInterrupts();
}

void prgm800Hz() {
	cycleData.intFlag = 0;
	cycleData.Cnt++;
	if (cycleData.Cnt == 1) {
		updateSpeeds();
		cycleData.Cnt = 0;
	}
}

// encoder pulses: front left, front right, rear left, rear right
ISR(INT0_vect) {
	addFLCounter();
}
ISR(INT1_vect) {
	addFRCounter();
}
ISR(INT6_vect) {
	addRLCounter();
}
ISR(INT7_vect) {
	addRRCounter();
}

// 800 Hz
ISR(TIMER1_COMPA_vect){
	cycleData.intFlag = 1;
}

// </meas>

MAKE_USART_INIT(1) // brakes

int main() {
	clock_prescale_set(clock_div_1);
	measinit();
	usart_1_init(38400);
	init();
	avr_sched_init();
	board_init();
	sei();
	for (;;) {
		avr_iter(); // TODO: buf_rxslave here?

		// meas
		if(cycleData.intFlag)
			prgm800Hz();
	}
}
