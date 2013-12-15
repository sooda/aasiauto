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

	while (msgs_work(BUF_RXHOST) == 0)
		;

	sensors_update();
	driveiter();
	assert(transmit_vals() == 0);

	return comm_txsize();
}
