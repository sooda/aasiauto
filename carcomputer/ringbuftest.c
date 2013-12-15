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

// identical bufs, test with BUF_RXHOST
#define buf_putchar(c) ringbuf_putchar(BUF_RXHOST, c)
#define buf_getchar() ringbuf_getchar(BUF_RXHOST)
#define buf_peek(b, n) ringbuf_peek(BUF_RXHOST, b, n)
#define buf_size() ringbuf_size(BUF_RXHOST)
#define buf_write(b, n) ringbuf_write(BUF_RXHOST, b, n)
#define buf_read(b, n) ringbuf_read(BUF_RXHOST, b, n)
#define buf_empty() ringbuf_empty(BUF_RXHOST)

void hw_to_user() {
	testinit();
	// empty at start
	expect_i(0, buf_size());

	// one character inserted
	buf_putchar('o');
	expect_i(1, buf_size());

	// fill a bit more
	buf_putchar(' ');
	buf_putchar('h');
	buf_putchar('a');
	buf_putchar('i');
	expect_i(5, buf_size());

	uint8_t buf[100], n;
	// there should be something
	n = buf_peek(buf, 2);
	expect_i(2, n);
	expect_c('o', buf[0]);
	expect_c(' ', buf[1]);

	// but peeking should not decrease its size
	expect_i(5, buf_size());

	// now actually reduce the size, check retrieved contents too
	// TODO separate buffers
	n = buf_read(buf, 2);
	expect_i(2, n);
	expect_c('o', buf[0]);
	expect_c(' ', buf[1]);
	// reduced?
	expect_i(3, buf_size());

	// can take only what is there
	n = buf_read(buf, 99);
	expect_i(3, n);
	expect_c('h', buf[0]);
	expect_c('a', buf[1]);
	expect_c('i', buf[2]);

	// now it's empty?
	n = buf_read(buf, 99);
	expect_i(0, n);
}

void user_to_hw() {
	testinit();
	uint8_t n;
	// put something there
	n = buf_write("o hai", 5);
	expect_i(5, n);
	expect_i(5, buf_size());

	// try to put more, it fills up
	n = buf_write("p hai", 5);
	expect_i(2, n);
	expect_i(7, buf_size());

	// read everything out
	n = buf_getchar(); expect_c('o', n);
	n = buf_getchar(); expect_c(' ', n);
	n = buf_getchar(); expect_c('h', n);
	n = buf_getchar(); expect_c('a', n);
	n = buf_getchar(); expect_c('i', n);
	n = buf_getchar(); expect_c('p', n);
	n = buf_getchar(); expect_c(' ', n);
	expect_i(1, buf_empty());

	// put shit in again
	n = buf_write("q hai", 5);
	expect_i(5, n);
	expect_i(5, buf_size());

	// read back
	n = buf_getchar(); expect_c('q', n);
	n = buf_getchar(); expect_c(' ', n);
	n = buf_getchar(); expect_c('h', n);
	n = buf_getchar(); expect_c('a', n);
	n = buf_getchar(); expect_c('i', n);
}

int main() {
	hw_to_user();
	hw_to_user();
	ringbuf_reset();
	user_to_hw();
	user_to_hw();
}
