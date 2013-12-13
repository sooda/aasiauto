#ifndef MSGS_H
#define MSGS_H

#include <stdint.h>

typedef void (*msg_handler)(uint8_t sz, uint8_t id);

void msgs_register_handler(uint8_t buf, uint8_t type, uint8_t size, msg_handler handler);

int8_t msgs_work(uint8_t bufid);

// no pings from the host for a while -> stop controlling and transmitting
// until next ping arrives
void msgwatchdog_reset(void);
// 0 if can run
uint8_t msgwatchdog(void);

#define MSG_TYPE_MAX 254

#define MSG_ERR_NOTYPE 0
#define MSG_ERR_SIZE_MISMATCH 1
#define MSG_ERR_PROXIED_MASK 0x80

#endif
