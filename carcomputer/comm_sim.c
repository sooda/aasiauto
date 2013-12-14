#include "comm.h"
#include "comm_sim.h"
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

uint16_t comm_rxsize(void) {
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

void comm_ignore(uint8_t nbytes) {
	assert(matlabbuf_rp + nbytes <= SIM_BUF_MAX);
	matlabbuf_rp += nbytes;
}


uint16_t comm_peek_u16(void) {
	uint16_t x;
	sim_peek(&x, sizeof(x));
	return x;
}

uint16_t comm_u16(void) {
	uint16_t x;
	sim_read(&x, sizeof(x));
	return x;
}

void dump_info(uint8_t stream, uint16_t type, uint16_t size, void *data) {
	(void)stream;
	sim_write(&size, sizeof(size));
	sim_write(&type, sizeof(type));
	sim_write(data, size);
}
