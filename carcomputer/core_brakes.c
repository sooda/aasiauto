#include "core_common.h"
#include "core.h"
#include "config.h"
#include "encoders.h"
#include "servos.h"
#include "comm.h"
#include "msgs.h"
#include "uartbuf.h"
#include "pwm.h"
#include <stdlib.h>
#include <stdio.h>

void sensors_update(void) {
	// no sensors here, just driving the brake servos
}

static void param_saver_brakes(uint8_t sz, uint8_t id) {
	(void)sz;
	uint16_t arg = comm_u16(BUF_RXHOST);
	id -= MSG_BRAKE_PARAMS_START;
	if (id <= 3)
		servo_neutral(id, arg);
	else if (id >= 4 && id <= 7) // deviation from the middle pos?
		servo_max(id - 4, arg);
}

static void param_saver_abs(uint8_t sz, uint8_t id) {
	(void)sz; (void)id;
	uint16_t param = comm_u16(BUF_RXHOST);
	(void)param;
	// TODO store the new value
}

static void param_saver_esp(uint8_t sz, uint8_t id) {
	(void)sz; (void)id;
	uint16_t param = comm_u16(BUF_RXHOST);
	(void)param;
	// TODO store the new value
}

// u16 params
// HOX end-inclusive
static void init_param_array(uint8_t start, uint8_t end, msg_handler handler) {
	for (; start <= end; start++) {
		msgs_register_handler(BUF_RXHOST, start, sizeof(uint16_t), handler);
	}
}

static void *imu_dump(void *p) {
	// FIXME implement
	static struct {
		int16_t xacc, yacc, zacc;
		int16_t xgyr, ygyr, zgyr;
	} state;
	return memcpy(p, &state, sizeof(state)) + sizeof(state);
}

static void brake_cmd(uint8_t sz, uint8_t id) {
	(void)sz; (void)id;
	static struct brk {
		uint16_t fl, fr, rl, rr;
	} brk;
	uartbuf_read(BUF_RXHOST, &brk, sizeof(brk));
	servo_set(PWM_BRAKE_FR, brk.fr/2);
	servo_set(PWM_BRAKE_FL, brk.fl/2);
	servo_set(PWM_BRAKE_RL, brk.rl/2);
	servo_set(PWM_BRAKE_RR, brk.rr/2);
}

static void dump_params(uint8_t sz, uint8_t id) {
	(void)sz; (void)id;
	uint16_t x;
	for (uint8_t i = 0; i < 4; i++) {
		x = servo_neutral_get(i);
		DUMP_INFO(MSG_BRAKE_PARAMS_START + i, x);
	}
	for (uint8_t i = 0; i < 4; i++) {
		x = servo_max_get(i);
		DUMP_INFO(MSG_BRAKE_PARAMS_START + 4 + i, x);
	}
	dump_info(BUF_TXHOST, MSG_PARAMS_EOF, 0, NULL);
}

// read just the encoder data, ignore everything else
// the standard measurement vector is sent here also
static void meas_from_wheelctl(uint8_t sz, uint8_t id) {
	(void)sz; (void)id;
	struct encoderstate enc;
	uartbuf_read(BUF_RXSLAVE, &enc, sizeof(enc));
	comm_ignore(BUF_RXSLAVE, (6+3)*sizeof(uint16_t));
	encoders_update(enc);
}

void init() {
	init_common();
	pwm_init();
	servos_init();
	init_param_array(MSG_BRAKE_PARAMS_START, MSG_BRAKE_PARAMS_END, param_saver_brakes);
	init_param_array(MSG_ABS_PARAMS_START, MSG_ABS_PARAMS_END, param_saver_esp);
	init_param_array(MSG_ESP_PARAMS_START, MSG_ESP_PARAMS_END, param_saver_abs);
	msgs_register_handler(BUF_RXHOST, MSG_BRAKE, 4*sizeof(uint16_t), brake_cmd);

	msgs_register_handler(BUF_RXSLAVE, MSG_CAR_MEAS_VECTOR,
			MEAS_NITEMS*sizeof(uint16_t), meas_from_wheelctl);
	msgs_register_handler(BUF_RXHOST, MSG_REQ_PARAMS, 0, dump_params);
}

void failmode(void) {
	// TODO: brakes 100%
}

/* write the state vector to a single packet and send it to the host */
// TODO: generalize me, no copypasta please
uint8_t transmit_vals(void) {
	if (msgwatchdog()) {
		failmode();
		return 1;
	}
	static struct {
		uint8_t sz, type;
		uint16_t data[MEAS_NITEMS];
	} packet = {
		.sz = MEAS_NITEMS * sizeof(uint16_t),
		.type = MSG_CAR_MEAS_VECTOR,
		.data = {0},
	};

	uint16_t *p = packet.data;

	p = encoders_dump(p);
	p = imu_dump(p); // acc, gyro

	HOSTBUF_DUMP(packet);

	return 0;
}

void driveiter(void) {
	// abs here
}
