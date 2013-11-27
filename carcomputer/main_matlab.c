#include "comm_sim.h"
#include "core.h"
#include "msgs.h"
#include <stdint.h>
#include <string.h>

/* Simulation from matlab
 *
 * Matlab ctrl cycle: feed in sensor state, compute, output ctrls
 * sensor simulation by feeding in the "measured" data, opposite of
 * the data reporting to host
 */

int matlab_ctrl(int n, uint8_t* in, uint8_t* out) {
	static int initd;
	if (!initd) {
		init();
		initd = 1;
	}

	comm_simulate(n, in, out);
	// FIXME: sync the control loop so that new data is buffered first and
	// switched to at once
	
	// assume that the data doesn't come in at blazing speeds
	// just process whatever there is so far
	while (msgs_work() == 0)
		;

	driveiter();
	transmit_vals();

	return comm_txsize();
}
