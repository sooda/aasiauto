#include "core.h"
#include "encoders.h"
#include "comm.h"
#include "msgs.h"
#include "wheelSpeeds.h"

void sensors_update(void) {
	rData_t speeds = getSpeeds();
	struct encoderstate st;
	st.fleft = speeds.FLeft;
	st.fright = speeds.FRight;
	st.rleft = speeds.RLeft;
	st.rright = speeds.RRight;
	encoders_update(st);
}

void init() {
	init_common();
}

/* write the state vector to a single packet and send it to the host */
uint8_t transmit_vals(void) {
	sensors_update();

	if (msgwatchdog())
		return 1;

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

	HOSTBUF_DUMP(packet);

	return 0;
}

void driveiter(void) {
	// no controls here
}
