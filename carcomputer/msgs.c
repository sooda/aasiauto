#include "msgs.h"
#include "comm.h"
#include <stdlib.h>
#include <assert.h>

msg_handler msg_handlers[MSG_TYPE_MAX];
uint8_t msg_sizes[MSG_TYPE_MAX];

void msgs_register_handler(uint8_t type, uint8_t size, msg_handler handler) {
	assert(msg_handlers[type] == NULL);
	assert(type < MSG_TYPE_MAX);
	msg_handlers[type] = handler;
	msg_sizes[type] = size;
}

int8_t msgs_work(void) {
	// TODO: several serial feeds (radio, teensy)
	uint16_t buf = comm_rxsize();
	// space for headers?
	if (buf < 4)
		return -1;

	uint16_t size = comm_peek_u8();
	// can has whole packet?
	if (4 + buf < size)
		return -1;

	// ready to go, flush size out
	comm_u8();

	uint16_t type = comm_u8();
	// if host code mismatches, inform about it and ignore the packet
	if (type >= MSG_TYPE_MAX) {
		comm_error(MSG_ERR_NOTYPE);
		comm_ignore(size);
		return -1;
	}
	
	if (!msg_handlers[type]) {
		comm_error(MSG_ERR_NOTYPE);
		comm_ignore(size);
		return -1;
	}

	if (size != msg_sizes[type]) {
		comm_error(MSG_ERR_SIZE_MISMATCH);
		comm_ignore(size);
		return -1;
	}

	msg_handlers[type](size, type);

	return 0;
}
