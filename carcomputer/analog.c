#include "analog.h"
#include "config.h"
#include "adc.h"
#include <stdint.h>
#include <string.h>

static struct anadata {
	uint16_t steerangle;
	uint16_t mainbattery;
	uint16_t drivebattery;
} state;

void ana_meas_init(void) {
	adc_init();
}

void ana_meas_update(void) {
	state.steerangle = adc_read(ADC_STEER);
	state.mainbattery = adc_read(ADC_MAINBATTERY);
	state.drivebattery = adc_read(ADC_DRIVEBATTERY);
}

void *ana_meas_dump(void *p) {
	return memcpy(p, &state, sizeof(state)) + sizeof(state);
}

