#include "core.h"
#include "msgs.h"
#include "comm.h"
#include "config.h"

static void pingpong(uint8_t sz, uint8_t id) {
	(void)sz; (void)id;
	uint16_t my_id = MY_ID;
	DUMP_INFO(MSG_PONG, my_id);
	msgwatchdog_reset();
	if (HAS_SLAVE)
		dump_info(BUF_TXSLAVE, MSG_PING, 0, NULL);
}

static void pongproxy(uint8_t sz, uint8_t id) {
	(void)sz; (void)id;
	uint16_t sender;
	COMM_PROXY(BUF_RXSLAVE, BUF_TXHOST, MSG_PONG, sender);
}

static void errproxy(uint8_t sz, uint8_t id) {
	(void)sz; (void)id;
	uint16_t err_sender_param[3];
	//uartbuf_read(BUF_RXSLAVE, &err_sender_param, sizeof(err_sender_param));
	COMM_PROXY(BUF_RXSLAVE, BUF_TXHOST, MSG_ERR, err_sender_param);
}

void init_common(void) {
	msgs_register_handler(BUF_RXHOST, MSG_PING, 0, pingpong);
	if (HAS_SLAVE) {
		msgs_register_handler(BUF_RXSLAVE, MSG_PONG, sizeof(uint16_t), pongproxy);
		msgs_register_handler(BUF_RXSLAVE, MSG_ERR, 3*sizeof(uint16_t), errproxy);
	}
}

// transmit data and blink the led (FIXME: rename me)
void transmit(void) {
	static uint8_t subid;
	uint8_t err = transmit_vals();
	if (err) {
		if ((subid++ & 0x3f) == 0) // ~ 1s period (100hz update, 64 toggles)
			heartbeat();
	} else {
		if ((subid++ & 0x3) == 0) // ~ 0.1s period (10 vs 4 as above)
			heartbeat();
	}
}
