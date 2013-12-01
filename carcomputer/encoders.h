#ifndef ENCODERS_H
#define ENCODERS_H

#include <stdint.h>

struct encoderstate {
	int16_t fleft, fright;
	int16_t rleft, rright;
} __attribute__((packed));

void encoders_init(void);
// TODO read from the stream, doh
void encoders_update(struct encoderstate newstate);
void *encoders_dump(void *p);
struct encoderstate encoders(void);

#endif
