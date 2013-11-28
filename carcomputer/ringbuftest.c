#include "comm_avr.h"
#include "ringbuf.h"
#include <stdio.h>

// macros because line numbers

#if 1
// Expect a particular character
#define expect_c(wanted, got) do { \
	char c = got; \
	printf("'%c' == '%c'\n", wanted, c); \
	assert(wanted == c); \
	} while (0)

// Expect a particular integer
#define expect_i(wanted, got) do { \
	int i = got; \
	printf("%d == %d\n", wanted, i); \
	assert(wanted == i); \
	} while (0)
#else
#define expect_c(w, g) assert(w == g)
#define expect_i(w, g) assert(w == g)
#endif

#define testinit() printf("starting %s()\n", __func__)

void hw_to_user() {
	testinit();
	// empty at start
	expect_i(0, hostbuf_size());

	// one character inserted
	uartbuf_putchar(BUF_RXHOST, 'o');
	expect_i(1, hostbuf_size());

	// fill a bit more
	uartbuf_putchar(BUF_RXHOST, ' ');
	uartbuf_putchar(BUF_RXHOST, 'h');
	uartbuf_putchar(BUF_RXHOST, 'a');
	uartbuf_putchar(BUF_RXHOST, 'i');
	expect_i(5, hostbuf_size());

	char buf[100], n;
	// there should be something
	n = hostbuf_peek(buf, 2);
	expect_i(2, n);
	expect_c('o', buf[0]);
	expect_c(' ', buf[1]);

	// but peeking should not decrease its size
	expect_i(5, hostbuf_size());

	// now actually reduce the size, check retrieved contents too
	// TODO separate buffers
	n = hostbuf_read(buf, 2);
	expect_i(2, n);
	expect_c('o', buf[0]);
	expect_c(' ', buf[1]);
	// reduced?
	expect_i(3, hostbuf_size());

	// can take only what is there
	n = hostbuf_read(buf, 99);
	expect_i(3, n);
	expect_c('h', buf[0]);
	expect_c('a', buf[1]);
	expect_c('i', buf[2]);

	// now it's empty?
	n = hostbuf_read(buf, 99);
	expect_i(0, n);
}

void user_to_hw() {
	char n;
	// put something there
	n = hostbuf_write("o hai", 5);
	expect_i(5, n);
	expect_i(5, uartbuf_size(BUF_TXHOST));

	// try to put more, it fills up
	n = hostbuf_write("p hai", 5);
	expect_i(2, n);
	expect_i(7, uartbuf_size(BUF_TXHOST));

	// read everything out
	n = uartbuf_getchar(BUF_TXHOST); expect_c('o', n);
	n = uartbuf_getchar(BUF_TXHOST); expect_c(' ', n);
	n = uartbuf_getchar(BUF_TXHOST); expect_c('h', n);
	n = uartbuf_getchar(BUF_TXHOST); expect_c('a', n);
	n = uartbuf_getchar(BUF_TXHOST); expect_c('i', n);
	n = uartbuf_getchar(BUF_TXHOST); expect_c('p', n);
	n = uartbuf_getchar(BUF_TXHOST); expect_c(' ', n);
	expect_i(1, uartbuf_empty(BUF_TXHOST));

	// put shit in again
	n = hostbuf_write("q hai", 5);
	expect_i(5, n);
	expect_i(5, uartbuf_size(BUF_TXHOST));

	// read back
	n = uartbuf_getchar(BUF_TXHOST); expect_c('q', n);
	n = uartbuf_getchar(BUF_TXHOST); expect_c(' ', n);
	n = uartbuf_getchar(BUF_TXHOST); expect_c('h', n);
	n = uartbuf_getchar(BUF_TXHOST); expect_c('a', n);
	n = uartbuf_getchar(BUF_TXHOST); expect_c('i', n);
}

int main() {
	hw_to_user();
	hw_to_user();
	user_to_hw();
	user_to_hw();
}
