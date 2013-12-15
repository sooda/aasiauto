#include "comm.h"
#include "comm_sim.h"
#include "uartbuf.h"
#include <stdio.h>
#include <assert.h>
#include <string.h>


static uint8_t *matlabbuf_r;
static uint8_t *matlabbuf_w;
static int matlabbuf_wp, matlabbuf_rp, matlabbuf_insz;

void comm_simulate(int n, uint8_t *in, uint8_t *out) {
	matlabbuf_r = in;
	matlabbuf_w = out;
	matlabbuf_wp = 0;
	matlabbuf_rp = 0;
	matlabbuf_insz = n;
}

int comm_txsize(void) {
	return matlabbuf_wp;
}

// XXX 8 bits enough?
uint8_t comm_rxsize(uint8_t id) {
	assert(id == BUF_RXHOST);
	return matlabbuf_insz - matlabbuf_rp;
}

void sim_write(void *data, uint16_t size) {
	assert(matlabbuf_wp + size <= SIM_BUF_MAX);
	memcpy(&matlabbuf_w[matlabbuf_wp], data, size);
	matlabbuf_wp += size;
}

void sim_read(void *data, uint16_t size) {
	assert(matlabbuf_rp + size <= SIM_BUF_MAX);
	memcpy(data, &matlabbuf_r[matlabbuf_rp], size);
	matlabbuf_rp += size;
}

void sim_peek(void *data, uint16_t size) {
	assert(matlabbuf_rp + size <= SIM_BUF_MAX);
	memcpy(data, &matlabbuf_r[matlabbuf_rp], size);
}

void comm_ignore(uint8_t buf, uint8_t nbytes) {
	assert(buf == BUF_RXHOST);
	assert(matlabbuf_rp + nbytes <= SIM_BUF_MAX);
	matlabbuf_rp += nbytes;
}


uint16_t comm_peek_u16(uint8_t buf) {
	assert(buf == BUF_RXHOST);
	uint16_t x;
	sim_peek(&x, sizeof(x));
	return x;
}

uint16_t comm_u16(uint8_t buf) {
	assert(buf == BUF_RXHOST);
	uint16_t x;
	sim_read(&x, sizeof(x));
	return x;
}

uint8_t comm_peek_u8(uint8_t buf) {
	assert(buf == BUF_RXHOST);
	uint8_t x;
	sim_peek(&x, sizeof(x));
	return x;
}

uint8_t comm_u8(uint8_t buf) {
	assert(buf == BUF_RXHOST);
	uint8_t x;
	sim_read(&x, sizeof(x));
	return x;
}

void uartbuf_write(uint8_t buf, void *ptr, uint8_t n) {
	assert(buf == BUF_TXHOST);
	sim_write(ptr, n);
}
#if 0
uint8_t uartbuf_peek(uint8_t buf, void *ptr, uint8_t n) {
	assert(buf == BUF_RXHOST);
	sim_peek(ptr, n);
}
#endif
void uartbuf_read(uint8_t buf, void *ptr, uint8_t n) {
	assert(buf == BUF_RXHOST);
	sim_read(ptr, n);
}

void dump_info(uint8_t stream, uint8_t type, uint8_t size, void *data) {
	assert(stream == BUF_TXHOST);
	sim_write(&size, sizeof(size));
	sim_write(&type, sizeof(type));
	sim_write(data, size);
}
