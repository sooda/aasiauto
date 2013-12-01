#include "adc.h"
#include <avr/io.h>

// last 5 bits select the channel
#define channel_select(x) (ADMUX = (ADMUX & ~0x1f) | (x))
#define start_conversion() (ADCSRA |= _BV(ADSC))
#define wait_conversion() do { loop_until_bit_is_clear(ADCSRA, ADSC); ADCSRA |= _BV(ADIF); } while (0)

void adc_init(void) {
	// enable, use AVCC reference
	ADCSRA = _BV(ADEN);// | _BV(REFS0);
	ADMUX = _BV(REFS0);
	// prescale 128, most stable
	ADCSRA |= _BV(ADPS0);
	ADCSRA |= _BV(ADPS1);
	ADCSRA |= _BV(ADPS2);
}

uint16_t adc_read(uint8_t channel) {
	channel_select(channel);
	start_conversion();
	wait_conversion();
	return ADC;
}
