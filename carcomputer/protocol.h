#ifndef PROTOCOL_H
#define PROTOCOL_H

// ID numbers for the messages

#define MSG_PING 0
#define MSG_PONG 1
#define MSG_REQ_PARAMS 2
#define MSG_REQ_PARAMS_FROM_HOST_WHATS_THIS 3
#define MSG_ERR 4
#define MSG_BRAKE_PARAMS_START 10
#define MSG_BRAKE_PARAMS_END 17
#define MSG_ABS_PARAMS_START 20
#define MSG_ABS_PARAMS_END 35
#define MSG_ESP_PARAMS_START 40
#define MSG_ESP_PARAMS_END 56
#define MSG_PARAMS_EOF 99
#define MSG_CAR_MEAS_VECTOR 110
#define MSG_THROTTLE 120
#define MSG_STEER 121
#define MSG_BRAKE 122
#define MSG_HORN 123

#define MEAS_NITEMS 13 // number of scalar elements, not bytes

#define MSG_HDRSIZE 2 // u8:size, u8:id

#define MSG_TYPE_MAX 254
#define MSG_ERR_NOTYPE 0
#define MSG_ERR_SIZE_MISMATCH 1
#define MSG_ERR_PROXIED_MASK 0x80

#endif
