#include "core.h"
#include "encoders.h"
#include "motors.h"
#include "servos.h"
#include "analog.h"
#include "comm.h"
#include "msgs.h"
#include "pwm.h"
#ifndef MCU_SIM
#include "uart.h" // ?
#endif

void steer(uint8_t sz, uint8_t id) {
	(void)sz; (void)id;
	pwm_set(PWM_STEERING, (int16_t)comm_u16(BUF_RXHOST));
}

void steering_init(void) {
	msgs_register_handler(BUF_RXHOST, MSG_STEER, sizeof(uint16_t), steer);
}

void sensors_update(void) {
	ana_meas_update();
}

// ping pong the actual brake command to the brake ctrlr
static void brake_cmd_proxy(uint8_t sz, uint8_t id) {
	(void)sz; (void)id;
	static struct brk {
		uint16_t fl, fr, rl, rr;
	} brk;
	uartbuf_read(BUF_RXHOST, &brk, sizeof(brk));
	dump_info(BUF_TXSLAVE, MSG_BRAKE, sizeof(brk), &brk);
}

static void brake_proxy(uint8_t sz, uint8_t id) {
	uint16_t param = comm_u16(BUF_RXHOST);
	dump_info(BUF_TXSLAVE, id, sz, &param);
}

static void brake_back_proxy(uint8_t sz, uint8_t id) {
	uint16_t param;
	if (sz)
		param = comm_u16(BUF_RXSLAVE);
	dump_info(BUF_TXHOST, id, sz, &param);
}

static void dump_params_proxy(uint8_t sz, uint8_t id) {
	(void)sz;
	dump_info(BUF_TXSLAVE, id, 0, NULL);
}

static void *imu_dump(void *p) {
	// FIXME implement
	static struct {
		int16_t xacc, yacc, zacc;
		int16_t xgyr, ygyr, zgyr;
	} state;
	return memcpy(p, &state, sizeof(state)) + sizeof(state);
}

static void meas_from_brakectl(uint8_t sz, uint8_t id) {
	(void)sz; (void)id;
	// TODO update those set by brakectl
	struct encoderstate enc;
	static struct imustate {
		int16_t xacc, yacc, zacc;
		int16_t xgyr, ygyr, zgyr;
	} imu;
	uartbuf_read(BUF_RXSLAVE, &enc, sizeof(enc));
	uartbuf_read(BUF_RXSLAVE, &imu, sizeof(imu));
	comm_ignore(BUF_RXSLAVE, 3*sizeof(uint16_t));
	encoders_update(enc);
}

// driver init; separate stuff for all three controllers
void init() {
	init_common();
	pwm_init();
	motors_init();
	steering_init();
	ana_meas_init();
	init_param_array(BUF_RXHOST, MSG_BRAKE_PARAMS_START, MSG_BRAKE_PARAMS_END, brake_proxy);
	init_param_array(BUF_RXHOST, MSG_ABS_PARAMS_START, MSG_ABS_PARAMS_END, brake_proxy);
	init_param_array(BUF_RXHOST, MSG_ESP_PARAMS_START, MSG_ESP_PARAMS_END, brake_proxy);
	msgs_register_handler(BUF_RXHOST, MSG_BRAKE, 4*sizeof(uint16_t), brake_cmd_proxy);

	msgs_register_handler(BUF_RXSLAVE, MSG_CAR_MEAS_VECTOR,
			MEAS_NITEMS*sizeof(uint16_t), meas_from_brakectl);

	msgs_register_handler(BUF_RXHOST, MSG_REQ_PARAMS, 0, dump_params_proxy);

	init_param_array(BUF_RXSLAVE, MSG_BRAKE_PARAMS_START, MSG_BRAKE_PARAMS_END, brake_back_proxy);
	init_param_array(BUF_RXSLAVE, MSG_ABS_PARAMS_START, MSG_ABS_PARAMS_END, brake_back_proxy);
	init_param_array(BUF_RXSLAVE, MSG_ESP_PARAMS_START, MSG_ESP_PARAMS_END, brake_back_proxy);
	msgs_register_handler(BUF_RXSLAVE, MSG_PARAMS_EOF, 0, brake_back_proxy);
}

#ifndef MCU_SIM
void failmode(void) {
	motorctl_set(0, 0);
	uarthost_desync();
}
#endif

/* write the state vector to a single packet and send it to the host */
uint8_t transmit_vals(void) {
#ifndef MCU_SIM
	if (msgwatchdog()) {
		failmode();
		return 1;
	}
#else
	struct encoderstate enc;
	encoders_update(enc);
#endif

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
	p = ana_meas_dump(p);

	HOSTBUF_DUMP(packet);

	return 0;
}

void driveiter(void) {
	// TODO: automatic drive etc.
}
