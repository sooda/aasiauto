#include "wheelSpeeds.h"
#include "initTeensy.h"
#include "usart.h"

#include <avr/io.h>
#include <avr/interrupt.h>

typedef struct {
    unsigned char intFlag;
    unsigned char Cnt;
} cycleData_t;

static cycleData_t cycleData;

void prgm100Hz(void);
void prgm800Hz(void);


int main(void) {
    cli();
    cycleData.intFlag = 0;
    cycleData.Cnt = 0;
    initWheelData();
    initPorts();
    initTimers();
    initUSART();
    initInterrupts();
    sei();
    for(;;) {
        if(cycleData.intFlag)
            prgm800Hz();
        if(cycleData.Cnt == 8)
            prgm100Hz();
    }
}

void prgm800Hz() {
    cycleData.intFlag = 0;
    cycleData.Cnt++;
    updateSpeeds();

}

void prgm100Hz(void) {
    cycleData.Cnt = 0;
    rData_t speeds = getSpeeds();
    rData_t acc = getAccelerations();
    //msgData_t msg = parseMsg(speeds, acc);
    //sendData(msg);

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

