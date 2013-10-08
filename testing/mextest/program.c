#include "program.h"

static double state[2];

/* Dummy test to return the sum of last and current value */
void compute(double *in, double *out) {
    int i;
    
    for (i = 0; i < 2; i++) {
        out[i] = in[i] + state[i];
        state[i] = in[i];
    }
}
