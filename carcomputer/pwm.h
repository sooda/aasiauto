#ifndef PWM_H
#define PWM_H

#include <stdint.h>

void pwm_set(uint8_t i, int16_t pos);
void pwm_set_raw(uint8_t i, uint16_t pos);
void pwm_init(void);

#endif
