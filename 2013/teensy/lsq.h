#ifndef RCCAR_LSQ_H
#define RCCAR_LSQ_H

#define SIZE 8

/*
 * Approximates least square fitted slope from data
 *
 * Uses 8 datapoints given in array *data
 * calculated with
 * slope = sum(vi*yi)
 * where 
 * vi = (xi-avg(x))*3 / 128
 *
 * slope returned is bitshifted to left by 4 bits ( << 4)
 */
int slope(unsigned char* data);

/* calculate mean of X
 * maybe optimized by compiler?
 */
int meanX(void);

/*calculate sum of C
 * optimized by compiler?
 */
int sumX(void);


#endif
