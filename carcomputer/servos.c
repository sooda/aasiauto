#include "comm.h"
#include "pwm.h"
#include <avr/eeprom.h>

struct servocfg {
	uint16_t center;
	int16_t max; // HOX max is relative to center, assumed symmetric
};

// FIXME brakes and steering separtely.

static struct servocfgs {
	struct servocfg cfg[4];
} state;

static struct servocfgs state_save EEMEM;

static void save(void) {
	eeprom_write_block(&state, &state_save, sizeof(state));
}

void servos_init(void) {
	eeprom_read_block(&state, &state_save, sizeof(state));
#if MCU_BRAKES
#if 1
	pwm_set_raw(0, state.cfg[0].center);
	pwm_set_raw(1, state.cfg[1].center);
	pwm_set_raw(2, state.cfg[2].center);
	pwm_set_raw(3, state.cfg[3].center);
#else
	pwm_set_raw(0, 1500); // front right
	pwm_set_raw(1, 1000); // front left
	pwm_set_raw(2, 1000); // rear left
	pwm_set_raw(3, 1500); // rear right
#endif
#endif
}

void servo_set(uint8_t id, int16_t pos) {
	// TODO remove the current pwm_set
	uint16_t center = state.cfg[id].center;
	int16_t max = state.cfg[id].max;

	if (pos > max)
		pos = max;
	else if (pos < -max) // ?
		pos = -max;

	pwm_set_raw(id, center + pos);
}

void servo_neutral(uint8_t id, uint16_t arg) {
	state.cfg[id].center = arg;
	save();
}

void servo_max(uint8_t id, uint16_t arg) {
	state.cfg[id].max = arg;
	save();
}

uint16_t servo_neutral_get(uint8_t id) {
	return state.cfg[id].center;
}

uint16_t servo_max_get(uint8_t id) {
	return state.cfg[id].max;
}
