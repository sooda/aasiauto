#ifndef MSGS_H
#define MSGS_H

#include <stdint.h>

typedef void (*msg_handler)(uint8_t sz, uint8_t id);

void msgs_register_handler(uint8_t buf, uint8_t type, uint8_t size, msg_handler handler);
// u16 params
// HOX end-inclusive
void init_param_array(uint8_t buf, uint8_t start, uint8_t end, msg_handler handler);

int8_t msgs_work(uint8_t bufid);

// no pings from the host for a while -> stop controlling and transmitting
// until next ping arrives
void msgwatchdog_reset(void);
// 0 if can run
uint8_t msgwatchdog(void);

#endif
