#include "config.h"
#include "encoders.h"
#include "motors.h"
#include "servos.h"
#include "comm.h"
#include "msgs.h"
#include "pwm.h"
#include <stdlib.h>

/* Common drive cycles for both simulation and real drive */


void steer(void) {
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
void pingpong(void) {
	dump_info(BUF_TXHOST, MSG_PONG, 0, NULL);
}

void init() {
	motors_init();
	steering_init();
	msgs_register_handler(MSG_PING, 0, pingpong);
}

/* write the state to a stream of buffer and send it to the host */
void transmit_vals() {
	encoders_dump();
}

void driveiter(void) {
	//steering_execute();
	//abs_execute();
}
