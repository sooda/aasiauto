# slightly deciphered from a matlab template
# works at least on kosh.aalto.fi
# TODO: experiment

MATLABDIR ?= /opt/matlab2013a
CC := gcc
CDEBUGFLAGS := -g
COPTIMFLAGS := -O -DNDEBUG
CFLAGS := -std=c99 -D_GNU_SOURCE -fexceptions -fPIC -fno-omit-frame-pointer # -pthread?
arguments := -DMX_COMPAT_32
CFLAGS += $(arguments)
CFLAGS += -I$(MATLABDIR)/extern/include -I$(MATLABDIR)/simulink/include -DMATLAB_MEX_FILE -Wall -Wextra
CFLAGS += $(CDEBUGFLAGS)
CFLAGS += -DMCU_SIM
LIBS := -lmx -lmex -lmat -lm -lstdc++
LDFLAGS := -pthread -shared -Wl,--version-script,$(MATLABDIR)/extern/lib/glnxa64/mexFunction.map -Wl,--no-undefined -Wl,-rpath-link,$(MATLABDIR)/bin/glnxa64 -L$(MATLABDIR)/bin/glnxa64 $(LIBS)

output := controller.mexa64
srcs := controller.c main_matlab.c core.c encoders.c comm_sim.c msgs.c comm.c pwm_sim.c motors.c
objs := $(patsubst %.c,%.o,$(srcs))

output: $(objs)
	$(CC) $(objs) -o $(output) $(LDFLAGS)

clean:
	rm -f $(objs) $(output)

.PHONY: clean
