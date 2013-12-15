#include "config.h"
#include "pwm.h"

int16_t pwmval[PWM_N];

void pwm_init(void) {
}

void pwm_set(uint8_t i, int16_t pos) {
	pwmval[i] = pos;
}

