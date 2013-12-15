#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <stdio.h>

int main() {
	//             ping.   throttle...............  steer.........
	uint8_t in[] = {0, 0,  4, 120, 100, 0, 200, 0,  2, 121, 100, 0}, sz = sizeof(in);
	uint8_t out[1024];

	extern int matlab_ctrl(int n, uint8_t* in, uint8_t* out);
	int n = matlab_ctrl(sz, in, out);
	for (int i = 0; i < n; i++) {
		printf("%d ", out[i]);
		// printout: pong + meas vector
	}
	printf("\n");
}

