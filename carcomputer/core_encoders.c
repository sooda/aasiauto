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
#include "wheelSpeeds.h"

void sensors_update(void) {
	// FIXME
#if 0
	struct encoderstate st;
	st.fleft = 12300;
	st.fright = 23400;
	st.rleft = 3450;
	st.rright = 4560;
	//encoders_update(st);
#endif
}

void init() {
	init_common();
}

/* write the state vector to a single packet and send it to the host */
uint8_t transmit_vals(void) {
	if (msgwatchdog())
		return 1;

	// XXX currently updated here, not in sensors_update()

	rData_t speeds = getSpeeds();
	struct encoderstate st;
	st.fleft = speeds.FLeft;
	st.fright = speeds.FRight;
	st.rleft = speeds.RLeft;
	st.rright = speeds.RRight;
	encoders_update(st);
	//msgData_t msg = parseMsg(speeds, acc);
	//sendData(msg);

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

	return 0;
}

void driveiter(void) {
	//read_user_input();
	//abs_execute();
}
