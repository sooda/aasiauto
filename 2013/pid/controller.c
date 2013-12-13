#include "program.h"
#include "mex.h"
#include <stdlib.h>

void mexFunction(int nlhs, mxArray *plhs[], 
		  int nrhs, const mxArray *prhs[]) {
    size_t cols, rows;
    double *in, *out;
    
    /* mexErrMsgIdAndTxt somehow returns from this function directly */
    if (nrhs != 1) { 
	    mexErrMsgIdAndTxt( "MATLAB:controller:ninputsfail",
                "I can has one parameters."); 
    } else if (nlhs != 1) {
	    mexErrMsgIdAndTxt( "MATLAB:controller:noutputsfail",
                "U can has one return value."); 
    } 
    
    cols = mxGetM(prhs[0]); 
    rows = mxGetN(prhs[0]);
    if (!mxIsDouble(prhs[0]) || cols != 1 || rows != 2) { 
	    mexErrMsgIdAndTxt("MATLAB:controller:inpsizefail",
                "The argument shall be a state vector of 2x1 doubles."); 
    } 
    
    plhs[0] = mxCreateDoubleMatrix(2, 1, mxREAL); 
    
    in = mxGetPr(prhs[0]);
    out = mxGetPr(plhs[0]);    
        
    compute(in, out);
}
