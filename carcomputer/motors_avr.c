#if 0
#include "motors.h"
#include "config.h"

void motorctl_update(uint16_t l, uint16_t r) {
	pwm_set(PWM_LEFTMOTOR, l);
	pwm_set(PWM_RIGHTMOTOR, l);
}
#endif
