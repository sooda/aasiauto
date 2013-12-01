#ifndef CONFIG_H
#define CONFIG_H

/* Hardware configuration: pin numbers etc. */

#ifdef MCU_MAIN

// OCR1A
#define PWM_LEFTMOTOR 0
// OCR1B
#define PWM_RIGHTMOTOR 1
// OCR3A
#define PWM_STEERING 2
// OCR3B: "clutch", not used

// uart indices; HW is teensy <=> brake <=> master <=> host
#define UART_MASTER 0

// serial: host
// serial1: brakes

#define ADC_STEER 0
#define ADC_MAINBATTERY 1
#define ADC_DRIVEBATTERY 2

#else
#ifdef MCU_BRAKES

// OCR1A front right
#define PWM_BRAKE_FR 0
// OCR1B front left
#define PWM_BRAKE_FL 1
// OCR3A rear left
#define PWM_BRAKE_RL 2
// OCR3B rear right
#define PWM_BRAKE_RR 3

// serial3: teensy
// serial1: main

#else
#ifdef MCU_SIM

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
#error No proper MCU defined.
#endif
#endif
#endif

#endif
