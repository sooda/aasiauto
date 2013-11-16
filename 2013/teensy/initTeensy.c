#include "initTeensy.h"
#include <avr/io.h>


void initTimers(void) {
    //Initializing Timer 1 to run with prescaler FCPU/8
    //and counting to 2500 (Gives interrupt interval of 800Hz)
    TCCR1B = (1<<WGM12) | (1<<CS11);
    OCR1AH = 0x09;
    OCR1AL = 0xC4;
    TIMSK1 = (1<<OCIE1A);
}

void initPorts(void) {
   //Enable pull-ups for encoder inputs
   PORTD = (1 << PD1) | (1 << PD0);
   PORTE = (1 << PE6) | (1 << PE7);
}

void initInterrupts(void) {
    // External Interrupt(s) initialization
    // INT0: On, Mode: Rising Edge
    // INT1: On, Mode: Rising Edge
    // INT6: On, Mode: Rising Edge
    // INT7: On, Mode: Rising Edge
    EICRA=(0<<ISC31) | (0<<ISC30) | (0<<ISC21) | (0<<ISC20) | (1<<ISC11) | (1<<ISC10) | (1<<ISC01) | (1<<ISC00);
    EICRB=(1<<ISC71) | (1<<ISC70) | (1<<ISC61) | (1<<ISC60) | (0<<ISC51) | (0<<ISC50) | (0<<ISC41) | (0<<ISC40);
    EIMSK=(1<<INT7) | (1<<INT6) | (0<<INT5) | (0<<INT4) | (0<<INT3) | (0<<INT2) | (1<<INT1) | (1<<INT0);
    EIFR=(1<<INTF7) | (1<<INTF6) | (0<<INTF5) | (0<<INTF4) | (0<<INTF3) | (0<<INTF2) | (1<<INTF1) | (1<<INTF0);
    PCMSK0=(0<<PCINT7) | (0<<PCINT6) | (0<<PCINT5) | (0<<PCINT4) | (0<<PCINT3) | (0<<PCINT2) | (0<<PCINT1) | (0<<PCINT0);
    PCICR=(0<<PCIE0);
}
