#include "msgs.h"
#include "comm.h"
#include "encoders.h"

static struct encoderstate state;

void encoders_dump(void) {
	DUMP_INFO(ENCODERS_STATE, state);
}

struct encoderstate encoders(void) {
	return state;
}

void throttle(void) {
	// placeholder example
	int16_t speedl = comm_u16();
	int16_t speedr = comm_u16();
	state.fleft = speedl;
	state.fright = speedr;
	state.rleft = speedl/2;
	state.rright = speedr/2;
}

void motors_init(void) {
	msgs_register_handler(MSG_THROTTLE, 2*sizeof(uint16_t), throttle);
}
