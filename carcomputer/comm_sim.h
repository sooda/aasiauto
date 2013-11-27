#ifndef COMM_SIM_H
#define COMM_SIM_H

#include <stdint.h>

void comm_simulate(int n, uint8_t *in, uint8_t *out);
int comm_txsize(void);

#include "comm.h"
#include <stdio.h>
#include <assert.h>


#define SIM_BUF_MAX 1024
void matlab_write(void *data, uint16_t size);
void matlab_read(void *data, uint16_t size);

#endif
