#ifndef MSGS_H
#define MSGS_H

#include <stdint.h>

typedef void (*msg_handler)(uint8_t sz, uint8_t id);

void msgs_register_handler(uint8_t type, uint8_t size, msg_handler handler);
int8_t msgs_work(void);

#define MSG_TYPE_MAX 255

#define MSG_ERR_NOTYPE 0
#define MSG_ERR_SIZE_MISMATCH 1

#endif
