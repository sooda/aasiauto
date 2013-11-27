#ifndef ENCODERS_H
#define ENCODERS_H

#include <stdint.h>

struct encoderstate {
	int16_t fleft, fright;
	int16_t rleft, rright;
} __attribute__((packed));

void encoders_init(void);
void encoders_update(int some_data_here);
void encoders_dump(void);
struct encoderstate encoders(void);
void motors_init(void);

#endif
