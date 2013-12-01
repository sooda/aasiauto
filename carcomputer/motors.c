#include "msgs.h"
#include "comm.h"
#include "motors.h"
#include "config.h"
#include "pwm.h"

static struct motorstate state;

struct motorstate motors(void) {
	return state;
}

static void throttle(void) {
	state.left = comm_u16();
	state.right = comm_u16();
	pwm_set(PWM_LEFTMOTOR, state.left);
	pwm_set(PWM_RIGHTMOTOR, state.right);
}

void motors_init(void) {
	msgs_register_handler(MSG_THROTTLE, 2*sizeof(uint16_t), throttle);
}
