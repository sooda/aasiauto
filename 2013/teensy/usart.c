#include "usart.h"
#include <avr/io.h>

void initUSART(void) {
    /* Set baud rate */
    UBRR1 = F_CPU/(16*BAUDRATE)-1;
    /* Enable receiver and transmitter */
    UCSR1B = (1<<RXEN1)|(1<<TXEN1);
    /* Set frame format: 8data, 1stop bit */
    UCSR1C = (3<<UCSZ10);
}

unsigned char RxByteUSART(void) {
    while(!(UCSR1A & (1 << RXC1)));
    return UDR1;
}

void TxByteUSART(unsigned char byte) {
    while(!(UCSR1A & (1<<UDRE1)));
    UDR1 = byte;
}

