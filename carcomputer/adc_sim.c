#include "adc.h"
#include "config.h"

static uint16_t adc[ADC_N];

void adc_init(void) {
}

uint16_t adc_read(uint8_t channel) {
	extern int16_t pwmval[PWM_N];
	if (channel == ADC_STEER)
		return pwmval[PWM_STEERING];
	return adc[channel];
}
