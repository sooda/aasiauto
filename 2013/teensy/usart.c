#include "usart.h"
#include <avr/io.h>

void initUSART(void) {
    /* Set baud rate */
    UBRRH1 = (unsigned char)(BAUDRATE>>8);
    UBRRL1 = (unsigned char)BAUDRATE;
    /* Enable receiver and transmitter */
    UCSR1B = (1<<RXEN1)|(1<<TXEN1);
    /* Set frame format: 8data, 2stop bit */
    UCSR1C = (1<<USBS1)|(3<<UCSZ10);
}

unsigned char RxByteUSART(void) {
    while(!(UCSR1A & (1 << RXC1)));
    return UDR1;
}

void TxByteUSART(unsigned char byte) {
    while(!(UCSR1A & (1<<UDRE1)));
    UDR1 = byte;
}

