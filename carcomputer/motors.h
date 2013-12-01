#ifndef MOTORS_H
#define MOTORS_H

#include <stdint.h>

struct motorstate {
	int16_t left, right;
} __attribute__((packed));

void motors_init(void);
struct motorstate motors(void);
void motorctl_update(uint16_t l, uint16_t r);

#endif
