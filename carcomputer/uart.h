#ifndef UART_H
#define UART_H

#include <avr/io.h>

void uart_flush(void);
void uartflush(void);

static inline void usart_init(unsigned long int baudrate) {
	// no 2X rate here
	int ubrr = (F_CPU + baudrate * 8UL) / (baudrate * 16UL) - 1;
	UBRR1H = (unsigned char)(ubrr >> 8);
	UBRR1L = (unsigned char)ubrr;
	UCSR1B = (1 << RXEN1) | (1 << TXEN1);
}

#endif
