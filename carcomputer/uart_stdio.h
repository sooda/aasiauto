#ifndef UART_STDIO_H
#define UART_STDIO_H

#include <stdio.h>

int uart_putchar(char c, FILE *stream);

#define stdio_setup(mystdout) do { stdout = &mystdout; stderr = &mystdout; } while (0)
#define STDIO_SETUP(mystdout) \
	static FILE mystdout = FDEV_SETUP_STREAM(uart_putchar, NULL, _FDEV_SETUP_WRITE)

#endif
