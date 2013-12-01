#include "msgs.h"
#include "comm.h"
#include "encoders.h"
#include "motors.h" // testing

static struct encoderstate state;

void *encoders_dump(void *p) {
	return memcpy(p, &state, sizeof(state)) + sizeof(state);
}

struct encoderstate encoders(void) {
	return state;
}
void encoders_update(struct encoderstate newstate) {
	// FIXME get them from teensy
#ifdef MCU_DRIVER
	state = newstate;
#else
	state.fleft = 1230;
	state.rleft = 2340;
	state.fright = 3450;
	state.rright = 4560;
#endif
}
