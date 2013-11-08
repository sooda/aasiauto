#include "wheelSpeeds.h"
#include <avr/io.h>
#include <avr/interrupt.h>

void initPorts();
void initTimers();
void initInterrupts();
void initComm();

void main() {
    unsigned char flag100Hz = 0, flag800Hz = 0;
    initWheelData();
    initPorts();
    initTimers();
    initComm();
    initInterrupts();
    for(;;) {
        if(flag100Hz)
            prgm800Hz();
        if(flag800Hz)
            prgm800Hz();
}

void prgm100Hz(void) {
    updateSpeeds();
}

void prgm800Hz(void) {
    rData_t speeds = getSpeeds();
    rData_t acc = getAccelerations();
    sendData(speeds);
    sendData(acc);

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
