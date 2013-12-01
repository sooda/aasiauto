#include "analog.h"
#include <stdint.h>
#include <string.h>

static struct anadata {
	uint16_t steerangle;
	uint16_t mainbattery;
	uint16_t drivebattery;
} state;

void ana_meas_init(void) {
	// TODO
}

void ana_meas_update(void) {
	// TODO
}

void *ana_meas_dump(void *p) {
	return memcpy(p, &state, sizeof(state)) + sizeof(state);
}

