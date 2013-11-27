#if 0
#include "comm.h"
#include <stdio.h>
#ifdef __AVR__
static int uart_putchar(char c, FILE *stream);
static int uart_putchar(char c, FILE *stream);
static FILE mystdout = FDEV_SETUP_STREAM(uart_putchar, NULL, _FDEV_SETUP_WRITE);
static FILE mystdin = FDEV_SETUP_STREAM(NULL, uart_getchar, _FDEV_SETUP_READ);
#define SERIAL_IN mystdin
#define SERIAL_OUT mystdout
#else
// WAT. read from a buffer... how to make it filelike?
// replace fread/fwrite altogether?
#define SERIAL_IN stdin
#define SERIAL_OUT stdout
#endif

void dump_info(uint16_t type, uint16_t size, void *data) {
	fwrite(&size, sizeof(size), 1, SERIALFILE);
	fwrite(&type, sizeof(type), 1, SERIALFILE);
	fwrite(&data, size, 1, SERIALFILE);
}

void recv_info(uint16_t *type, uint16_t *size, void *data) {
	fread(&size, sizeof(size), 1, SERIALFILE);
	fread(&type, sizeof(type), 1, SERIALFILE);
	fread(&data, size, 1, SERIALFILE);
}

void recv_info_check(uint16_t type, uint16_t size, void *data) {
	int rtype, rsize;
	recv_info(&rtype, &rsize, &data);
	assert(rtype == type);
	assert(rsize == size);
}
#endif

#include "comm.h"

void comm_error(uint16_t errnr) {
	DUMP_INFO(MSG_ERR, errnr);
}
