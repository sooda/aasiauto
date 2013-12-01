#ifndef UART_H
#define UART_H

#include <avr/io.h>

void uartflush_host(void);
void uartflush_slave(void);
#define uartflush(buf) (buf == BUF_TXHOST ? uartflush_host() : uartflush_slave())

// no 2X rate here
#define MAKE_USART_INIT(n) \
	static inline void usart_ ## n ## _init(unsigned long int baudrate) { \
		int ubrr = (F_CPU + baudrate * 8UL) / (baudrate * 16UL) - 1; \
		UBRR ## n ## H = (unsigned char)(ubrr >> 8); \
		UBRR ## n ## L = (unsigned char)ubrr; \
		UCSR ## n ## B = _BV(RXEN ## n) | _BV(TXEN ## n) \
		| _BV(RXCIE ## n) | _BV(TXCIE ## n); \
	}


#endif
