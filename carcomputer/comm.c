#include "comm.h"
#include "config.h"

void comm_error(uint16_t errnr, uint16_t param) {
	// FIXME: embed sender id to error number, we got dem bits
	struct { uint16_t nr, sender, arg; } x = {errnr, MY_ID, param};
	DUMP_INFO(MSG_ERR, x);
}
