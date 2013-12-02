#ifndef SERVOS_H
#define SERVOS_H

#include <stdint.h>

void servos_init(void);
void servo_set(uint8_t id, int16_t pos);
void servo_neutral(uint8_t id, uint16_t arg);
void servo_max(uint8_t id, uint16_t arg);
uint16_t servo_neutral_get(uint8_t id);
uint16_t servo_max_get(uint8_t id);

#endif
