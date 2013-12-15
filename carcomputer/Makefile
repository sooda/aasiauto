# slightly deciphered from a matlab template
# works at least on kosh.aalto.fi
# TODO: experiment

MATLABDIR ?= /opt/matlab2013a
CC := gcc
CFLAGS := -g -O0 -std=c99 -Wall -Wextra -DMCU_SIM -fpack-struct

# DNDEBUG?
# exceptions? no-omit? pthread?
CFLAGS_MEX := $(CFLAGS) -D_GNU_SOURCE -fexceptions -fPIC -fno-omit-frame-pointer -DMX_COMPAT_32 -I$(MATLABDIR)/extern/include -I$(MATLABDIR)/simulink/include -DMATLAB_MEX_FILE

LIBS := -lmx -lmex -lmat -lm -lstdc++
LDFLAGS_MEX := -pthread -shared -Wl,--version-script,$(MATLABDIR)/extern/lib/glnxa64/mexFunction.map -Wl,--no-undefined -Wl,-rpath-link,$(MATLABDIR)/bin/glnxa64 -L$(MATLABDIR)/bin/glnxa64 $(LIBS)

output := controller.mexa64
cli := controller_cli
srcs := main_matlab.c core_driver.c core_common.c encoders.c comm_sim.c msgs.c comm.c pwm_sim.c motors.c adc_sim.c analog.c
objs := $(patsubst %.c,%.o,$(srcs))

all: $(output) $(cli)

$(output): $(srcs) controller.c
	$(CC) $^ -o $@ $(CFLAGS_MEX) $(LDFLAGS_MEX)

$(cli): $(srcs) controller_cli.c
	$(CC) $^ -o $@ $(CFLAGS) $(LDFLAGS)

clean:
	rm -f $(objs) $(output)

.PHONY: clean
