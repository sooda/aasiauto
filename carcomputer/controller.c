#include "mex.h"
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

void mexFunction(int nlhs, mxArray *plhs[],
		int nrhs, const mxArray *prhs[]) {
	size_t cols, rows;

	/* mexErrMsgIdAndTxt somehow returns from this function directly */
	if (nrhs != 1) { 
		mexErrMsgIdAndTxt( "MATLAB:controller:ninputsfail",
				"Exactly one parameter please");
	} else if (nlhs != 1) {
		mexErrMsgIdAndTxt( "MATLAB:controller:noutputsfail",
				"Exactly one return value please");
	}

	rows = mxGetM(prhs[0]);
	cols = mxGetN(prhs[0]);
	if (!mxIsUint8(prhs[0]) || cols < 1 || rows != 1) {
		mexErrMsgIdAndTxt("MATLAB:controller:inpfmtfail",
				"The argument shall be a message vector of Nx1 uint8's.");
	}

	uint8_t *in = mxGetData(prhs[0]);
	uint8_t out[1024];

	extern int matlab_ctrl(int n, uint8_t* in, uint8_t* out);
	int n = matlab_ctrl(cols, in, out);

	plhs[0] = mxCreateNumericMatrix(1, n, mxUINT8_CLASS, mxREAL);
	uint8_t* out2 = mxGetData(plhs[0]);
	memcpy(out2, out, n);
}
