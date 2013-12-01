#include "pwm.h"
#include <avr/io.h>
#include <stdlib.h>
#include <assert.h>

void pwm_set(uint8_t i, uint16_t pos) {
	switch (i) {
		case 0: OCR1A = pos; break;
		case 1: OCR1B = pos; break;
		case 2: OCR3A = pos; break;
		case 3: OCR3B = pos; break;
		default: assert(0); break;
	}
}
