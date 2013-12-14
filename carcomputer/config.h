#ifndef CONFIG_H
#define CONFIG_H

/* Some common project-wide definitions */

// 1000 / this = transmit frequency
// (increase to make processing slower and easier to debug)
#warning turn back to 10 for 100 hz
#define TRANSMIT_PRESCALE 30
// how many iterations per second
// main timer rolls at 1000 Hz
#define HZ (1000/TRANSMIT_PRESCALE)

// half a second for emergency timeout
#define WATCHDOG_MAX (HZ/2)

// Ring buffer. Power of two, please
// bitmask and also index of last id
#define RBUF_SZMASK 255
#define RBUF_SIZE (RBUF_SZMASK+1)

#define BUF_TXHOST 0 // to host
#define BUF_RXHOST 1 // from host
// drive controller commands brakes, brakectl commands teensy
// (teensy does not and wouldn't need a slave buffer...)
#define BUF_TXSLAVE 2
#define BUF_RXSLAVE 3
#define RBUF_NBUFS 4

// magic. simplifies uart handling
#define UDRNUM1(x) UDR ## x
#define UDRNUM(x) UDRNUM1(x)

// handle received messages from host and from slave
#define N_STREAMS 2

/* Hardware configuration: pin numbers etc. */

// transmitter id numbers for at least ping and error messages
#define ID_DRIVER 0
#define ID_BRAKES 1
// FIXME: rename to speeds? length would match, yay!
#define ID_ENCODERS 2

#ifdef MCU_DRIVER
	#define MY_ID ID_DRIVER
	#define HAS_SLAVE 1 // do we need to proxy pings downwards etc.

	// OCR1A
	#define PWM_LEFTMOTOR 0
	// OCR1B
	#define PWM_RIGHTMOTOR 1
	// OCR3A
	#define PWM_STEERING 2
	// OCR3B: "clutch", not used

	// uart indices; HW is teensy <=> brake <=> driver <=> host
	#define UART_HOST 0
	#define UART_SLAVE 1

	#define ADC_STEER 0
	#define ADC_MAINBATTERY 1
	#define ADC_DRIVEBATTERY 2
#else
#ifdef MCU_BRAKES
	#define MY_ID ID_BRAKES
	#define HAS_SLAVE 1

	// OCR1A front right
	#define PWM_BRAKE_FR 0
	// OCR1B front left
	#define PWM_BRAKE_FL 1
	// OCR3A rear left
	#define PWM_BRAKE_RL 2
	// OCR3B rear right
	#define PWM_BRAKE_RR 3

	#define UART_HOST 1
	#define UART_SLAVE 3
#else
#ifdef MCU_SIM
	#define MY_ID ID_DRIVER // ?
	#define HAS_SLAVE 0
	
	#define PWM_LEFTMOTOR 0
	#define PWM_RIGHTMOTOR 1
	#define PWM_STEERING 2
	#define UART_MASTER 3
	#define PWM_BRAKE_FR 4
	#define PWM_BRAKE_FL 5
	#define PWM_BRAKE_RL 6
	#define PWM_BRAKE_RR 7
	#define PWM_N 8

#else
#ifdef MCU_ENCODERS
	#define MY_ID ID_ENCODERS
	#define HAS_SLAVE 0
	
	#define UART_HOST 1
#else
	#error No proper MCU defined.
#endif
#endif
#endif
#endif

#endif
