#include "usart.h"
#include <avr/io.h>

void initUSART(void) {
{
    UBRR = UBRRVALUE;
    /*Set Frame Format
    >> Asynchronous mode
    >> No Parity
    >> 1 StopBit
    >> char size 8
    */
    UCSRC=(1<<URSEL)|(3<<UCSZ0);
    //Enable The receiver and transmitter
    UCSRB=(1<<RXEN)|(1<<TXEN);
}

unsigned char RxByteUSART(void) {
    while(!(UCSRA & (1 << RXC)));
    return UDR;
}

void TxByteUSART(unsigned char byte) {
    while(!(UCSRA & (1<<UDRE)));
    UDR = byte;
}

