#include "config.h"
#include "encoders.h"
#include "servos.h"
#include "comm.h"
#include "msgs.h"
#include "uartbuf.h"
#include "pwm.h"
#include <stdlib.h>

void sensors_update(void) {
	// FIXME
	struct encoderstate st;
	encoders_update(st);
}

// TODO: make this a watchdog, stop if no ping in e.g. 10 ms
static void pingpong(uint8_t sz, uint8_t id) {
	(void)sz; (void)id;
	dump_info(BUF_TXHOST, MSG_PONG, 0, NULL);
}

static void param_saver_brakes(uint8_t sz, uint8_t id) {
	(void)sz; (void)id;
	uint16_t param = comm_u16(BUF_RXHOST);
	(void)param;
	// TODO store the new value
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
static void init_param_array(uint8_t start, uint8_t end, msg_handler handler) {
	for (; start < end; start++) {
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
	pwm_set(PWM_BRAKE_FR, brk.fr);
	pwm_set(PWM_BRAKE_FL, brk.fl);
	pwm_set(PWM_BRAKE_RL, brk.rl);
	pwm_set(PWM_BRAKE_RR, brk.rr);
	extern int initd;
	initd = 1;
}

void init() {
	pwm_init();
	init_param_array(MSG_BRAKE_PARAMS_START, MSG_BRAKE_PARAMS_END, param_saver_brakes);
	init_param_array(MSG_ABS_PARAMS_START, MSG_ABS_PARAMS_END, param_saver_esp);
	init_param_array(MSG_ESP_PARAMS_START, MSG_ESP_PARAMS_END, param_saver_abs);
	msgs_register_handler(BUF_RXHOST, MSG_BRAKE, 4*sizeof(uint16_t), brake_cmd);
	msgs_register_handler(BUF_RXHOST, MSG_PING, 0, pingpong);
}

/* write the state vector to a single packet and send it to the host */
void transmit_vals() {
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
}

void driveiter(void) {
	//read_user_input();
	//abs_execute();
}
