#include "msgs.h"
#include "comm.h"
#include "encoders.h"
#include "motors.h" // testing

static struct encoderstate state
#ifdef MCU_BRAKES
= {42, 1337, 42, 1337}
#endif
;

void *encoders_dump(void *p) {
	return memcpy(p, &state, sizeof(state)) + sizeof(state);
}

struct encoderstate encoders(void) {
	return state;
}
void encoders_update(struct encoderstate newstate) {
	// FIXME get them from teensy (HAX, almost done)
#ifdef MCU_DRIVER
	state = newstate;
#else
	(void)newstate;
#ifdef MCU_BRAKES
#if 0
	state.fleft = 1230;
	state.fright = 2340;
	state.rleft = newstate.rleft;
	state.rright = newstate.rright;
#else
	state = newstate;
#endif
#else
#if 0
	state.fleft = 12300;
	state.fright = 23400;
	state.rleft = 3450;
	state.rright = 4560;
#else
	state = newstate;
#endif
#endif
#endif
}
