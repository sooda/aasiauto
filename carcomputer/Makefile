# slightly deciphered from a matlab template
# works at least on kosh.aalto.fi
# TODO: experiment

CC := gcc
CDEBUGFLAGS := -g
COPTIMFLAGS := -O -DNDEBUG
CFLAGS := -std=c99 -D_GNU_SOURCE -fexceptions -fPIC -fno-omit-frame-pointer # -pthread?
arguments := -DMX_COMPAT_32
CFLAGS += $(arguments)
CFLAGS += -I/opt/matlab2013a/extern/include -I/opt/matlab2013a/simulink/include -DMATLAB_MEX_FILE -Wall -Wextra
CFLAGS += $(CDEBUGFLAGS)
LIBS := -lmx -lmex -lmat -lm -lstdc++
LDFLAGS := -pthread -shared -Wl,--version-script,/opt/matlab2013a/extern/lib/glnxa64/mexFunction.map -Wl,--no-undefined -Wl,-rpath-link,/opt/matlab2013a/bin/glnxa64 -L/opt/matlab2013a/bin/glnxa64 $(LIBS)

output := controller.mexa64
srcs := controller.c main_matlab.c core.c encoders.c comm_sim.c msgs.c comm.c
objs := $(patsubst %.c,%.o,$(srcs))

output: $(objs)
	$(CC) $(objs) -o $(output) $(LDFLAGS)

clean:
	rm -f $(objs) $(output)

.PHONY: clean
