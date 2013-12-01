#include "msgs.h"
#include "comm.h"
#include <stdlib.h>
#include <assert.h>
#include "config.h"
#include <stdio.h>

static struct msg_handler_data {
	msg_handler handler;
	uint8_t size;
} msg_handlers[N_STREAMS][MSG_TYPE_MAX];

void msgs_register_handler(uint8_t buf, uint8_t type, uint8_t size, msg_handler handler) {
	buf = (buf == BUF_RXHOST) ? 1 : 0;
	assert(type < MSG_TYPE_MAX);
	assert(msg_handlers[buf][type].handler == NULL);
	msg_handlers[buf][type].handler = handler;
	msg_handlers[buf][type].size = size;
}

int8_t msgs_work(uint8_t bufid) {
	// FIXME better indexing (divide by 2? get it from a single bit?)
	uint8_t handbuf = (bufid == BUF_RXHOST) ? 1 : 0;
	uint8_t available = comm_rxsize(bufid);

	if (available < MSG_HDRSIZE)
		return -1;

	uint8_t packsize = comm_peek_u8(bufid);
	// can has whole packet?
	if (available < MSG_HDRSIZE + packsize)
		return -1;

	// ready to go, flush size out
	comm_u8(bufid);

	uint8_t type = comm_u8(bufid);
	// if host code mismatches, inform about it and ignore the packet
	if (type > MSG_TYPE_MAX) {
		comm_error(MSG_ERR_NOTYPE, type);
		comm_ignore(bufid, packsize);
		return -1;
	}
	
	if (!msg_handlers[handbuf][type].handler) {
		comm_error(MSG_ERR_NOTYPE, type);
		comm_ignore(bufid, packsize);
		return -1;
	}

	if (packsize != msg_handlers[handbuf][type].size) {
		comm_error(MSG_ERR_SIZE_MISMATCH, type);
		comm_ignore(bufid, packsize);
		return -1;
	}

	//if (handbuf == 0) printf(" yhyy %d %d\n", packsize, type);
	//if (handbuf == 0) { comm_ignore(bufid, comm_rxsize(bufid)); return -1; }

	msg_handlers[handbuf][type].handler(packsize, type);

	return 0;
}
