#ifndef UARTBUF_H
#define UARTBUF_H

#include <stdint.h>
#include "ringbuf.h"

void uartbuf_write(uint8_t buf, void *ptr, uint8_t n);
uint8_t uartbuf_peek(uint8_t buf, void *ptr, uint8_t n);
void uartbuf_read(uint8_t buf, void *ptr, uint8_t n);

#endif
