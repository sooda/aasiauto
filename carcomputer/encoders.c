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
void encoders_update(void) {
	// test placeholder
	struct motorstate m = motors();
	state.fleft = m.left;
	state.rleft = m.left;
	state.fright = m.right;
	state.rright = m.right;
}
