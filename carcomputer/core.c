#include "encoders.h"
#include "comm.h"
#include "msgs.h"
#include <stdlib.h>

/* Common drive cycles for both simulation and real drive */

void sensors_update(void) {
	//encoders_update();
}

// TODO: make this a watchdog, stop if no ping in e.g. 10 ms
void pingpong(void) {
	dump_info(STREAM_HOST, MSG_PONG, 0, NULL);
}

void init() {
	motors_init();
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
