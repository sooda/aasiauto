#include "config.h"
#include "encoders.h"
#include "motors.h"
#include "servos.h"
#include "analog.h"
#include "comm.h"
#include "msgs.h"
#include "uartbuf.h"
#include "pwm.h"
#include <stdlib.h>

/* Common drive cycles for both simulation and real drive */


void steer(uint8_t sz, uint8_t id) {
	(void)sz; (void)id;
	pwm_set(PWM_STEERING, comm_u16());
//	hostbuf_read(&buf, sizeof(buf));
}

void steering_init(void) {
	msgs_register_handler(MSG_STEER, sizeof(uint16_t), steer);
}

void sensors_update(void) {
	encoders_update();
}

// TODO: make this a watchdog, stop if no ping in e.g. 10 ms
static void pingpong(uint8_t sz, uint8_t id) {
	(void)sz; (void)id;
	dump_info(BUF_TXHOST, MSG_PONG, 0, NULL);
}

static void brake_proxy(uint8_t sz, uint8_t id) {
	uint16_t param = comm_u16();
	dump_info(BUF_TXSLAVE, id, sz, &param);
}

// u16 params
static void init_param_array(uint8_t start, uint8_t end, msg_handler handler) {
	for (; start < end; start++) {
		msgs_register_handler(start, sizeof(uint16_t), handler);
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

void send_measurements(void) {
}

// driver init; separate stuff for all three controllers
void init() {
	pwm_init();
	motors_init();
	steering_init();
	init_param_array(MSG_BRAKE_PARAMS_START, MSG_BRAKE_PARAMS_END, brake_proxy);
	init_param_array(MSG_ABS_PARAMS_START, MSG_ABS_PARAMS_END, brake_proxy);
	init_param_array(MSG_ESP_PARAMS_START, MSG_ESP_PARAMS_END, brake_proxy);
	msgs_register_handler(MSG_PING, 0, pingpong);
}

/* write the state vector to a single packet and send it to the host */
void transmit_vals() {
	static struct {
		uint8_t sz, type;
		uint16_t data[MEAS_NITEMS * sizeof(uint16_t)];
		uint8_t eof;
	} packet = {
		.sz = MEAS_NITEMS * sizeof(uint16_t),
		.type = MSG_CAR_MEAS_VECTOR,
		.data = {0},
		.eof = MSG_PARAMS_EOF
	};

	uint16_t *p = packet.data;

	p = encoders_dump(p);
	p = imu_dump(p); // acc, gyro
	p = ana_meas_dump(p);

	HOSTBUF_DUMP(packet);
}

void driveiter(void) {
	//steering_execute();
	//abs_execute();
}
