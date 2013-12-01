#include "config.h"
#include "pwm.h"

uint16_t pwmval[PWM_N];

void pwm_set(uint8_t i, uint16_t pos) {
	pwmval[i] = pos;
}

