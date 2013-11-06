#include "lsq.h"

static unsigned char x[8] = {1, 2, 3, 4, 5, 6, 7, 8};
static int v[8];

static void fact(void) {
    for(unsigned char i =0; i < SIZE; ++i)
        v[i] = (((x[i] << 4) - meanX())*3);
}

int slope(unsigned char* data) {
    fact();
    int slope = 0;
    for(unsigned char i=0; i < SIZE; ++i)
        slope += v[i]*data[i];
    return slope >> 7; 
}

int meanX(void) {
    return sumX() << 1; // 4 to right and div by 8
}

int sumX(void) {
    int sum = 0;
    for(unsigned char i = 1; i <= SIZE; ++i)
        sum += i;
    return sum;
}

