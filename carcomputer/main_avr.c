#include "comm_sim.h"
#include "core.h"
#include "msgs.h"
#include <stdint.h>
#include <string.h>

/* Actual onboard drive
 *
 * read physical state from the sensors, compute, drive the actuators
 */

// TODO: set this in a timer
volatile uint8_t flag_transmit;
volatile uint8_t flag_drive;

int main() {
	init();
	for (;;) {
		msgs_work();
		sensors_update();
		if (flag_drive)
			driveiter();
		if (flag_transmit)
			transmit_vals();
	}
}
