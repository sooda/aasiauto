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

void init() {
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
	//memset(packet.data, 30, sizeof(packet.data));

	HOSTBUF_DUMP(packet);
}

void driveiter(void) {
	//read_user_input();
	//abs_execute();
}
