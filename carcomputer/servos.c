#include "comm.h"

struct servocfg {
	uint16_t center, min, max;
} __attribute__((packed));

// FIXME brakes and steering separtely.

static struct servocfgs {
	struct servocfg steering;
	struct servocfg frontleft, frontright;
	struct servocfg rearleft, rearright;
} state __attribute__((packed));

static struct servocfgs state_save EEMEM;

void servos_dump(void) {
	DUMP_INFO(SERVO_STATUS, state);
}

void servos_init(void) {
	servohw_init();
	eeprom_read_block(&state, &state_save, sizeof(state));
	pwm_set(0, state.steering.center);
	pwm_set(1, state.frontleft.center);
	pwm_set(2, state.frontright.center);
	pwm_set(3, state.rearleft.center);
	pwm_set(4, state.rearright.center);
}
