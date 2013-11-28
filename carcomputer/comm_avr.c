#include "comm.h"
#include "comm_avr.h"
#include "ringbuf.h"
#include <stdio.h>
#include <assert.h>
#include <string.h>

uint16_t comm_rxsize(void) {
	return hostbuf_size();
}

// these assume that the data exists already; if not, zero-filled
uint16_t comm_peek_u16(void) {
	uint16_t x = 0;
	hostbuf_peek(&x, sizeof(x));
	return x;
}

uint16_t comm_u16(void) {
	uint16_t x = 0;
	hostbuf_read(&x, sizeof(x));
	return x;
}

void dump_info(uint8_t stream, uint16_t type, uint16_t size, void *data) {
	(void)stream;
	hostbuf_write(&size, sizeof(size));
	hostbuf_write(&type, sizeof(type));
	hostbuf_write(data, size);
}

void comm_ignore(uint8_t nbytes) {
	hostbuf_read(NULL, nbytes);
}

#if 0
void recv_info(uint8_t stream, uint16_t *type, uint16_t *size, void *data) {
	(void)stream;
	sim_read(&size, sizeof(size));
	sim_read(&type, sizeof(type));
	sim_read(data, *size);
}

void recv_info_check(uint8_t stream, uint16_t type, uint16_t size, void *data) {
	(void)stream;
	int rtype, rsize;
	recv_info(&rtype, &rsize, data);
	assert(rtype == type);
	assert(rsize == size);
}
#endif
