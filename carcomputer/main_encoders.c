#include "uart.h"
#include "msgs.h"
#include "core.h"
#include "core_common.h"
#include "ringbuf.h"
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <avr/power.h>

// meas
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
	//initUSART();
	initInterrupts();
}

void heartbeat(void) {
	PORTD ^= _BV(6);
}

void prgm800Hz() {
	cycleData.intFlag = 0;
	cycleData.Cnt++;
	if (cycleData.Cnt == 1) { // e.g. 80 here to slow down
		updateSpeeds();
		cycleData.Cnt = 0;
	}
}

void prgm100Hz(void) {
#if 0
	cycleData.Cnt = 0;
	rData_t speeds = getSpeeds();
	rData_t acc = getAccelerations();
	//msgData_t msg = parseMsg(speeds, acc);
	//sendData(msg);
#endif
}
// The service routine for interrupt 0 (front left)
ISR(INT0_vect) {
	addFLCounter();
}

// The service routine for interrupt 1 (front right)
ISR(INT1_vect) {
	addFRCounter();
}

// The service routine for interrupt 6 (left rear)
ISR(INT6_vect) {
	addRLCounter();
}

// The service routine for interrupt 7 (right rear)
ISR(INT7_vect) {
	addRRCounter();
}

//The Timer1 Interrupt service routine
//Will be executed at rate of 800Hz
ISR(TIMER1_COMPA_vect){
	cycleData.intFlag = 1;
}

// </meas>

MAKE_USART_INIT(1) // brakes

volatile uint8_t flag_transmit; //  100 Hz
volatile uint8_t flag_drive;    // 1000 Hz

// 1000 Hz
ISR(TIMER0_COMPA_vect) {
	static uint8_t prescale;
	if (++prescale == 10) {
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

	measinit();

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
			transmit();
		}

		// meas
		if(cycleData.intFlag)
			prgm800Hz();
		//if(cycleData.Cnt == 8)
		//	prgm100Hz(); // done already in other places
	}
}
