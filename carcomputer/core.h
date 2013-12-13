#ifndef CORE_H
#define CORE_H

#include <stdint.h>

void sensors_update(void);
void init(void);
uint8_t transmit_vals(void);
void driveiter(void);

#endif
