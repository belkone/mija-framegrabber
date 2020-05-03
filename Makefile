CROSS_COMPILE ?=arm-linux-gnueabihf-
GCC ?= $(CROSS_COMPILE)gcc

C_FLAGS := -w -O2 -std=gnu99 -march=armv7-a -fPIC -DPIC -DOMXILCOMPONENTSPATH=\"/$(BUILD_DIR)\" -DCONFIG_DEBUG_LEVEL=255
C_INCLUDES := -I./include

LDFLAGS := -L./lib -lev -lshbf -lshbfev -lc-2.25 -lpthread-2.25 -lrt-2.25

PROGS = framegrabber

C_SRCS=$(wildcard ./src/*.c)
C_SRCS_NO_DIR=$(notdir $(C_SRCS))
OBJECTS=$(patsubst %.c, %.c.o,  $(C_SRCS_NO_DIR))

OBJDIR ?= $(shell pwd)/obj
BINDIR ?= $(shell pwd)/bin

OBJPROG = $(addprefix $(OBJDIR)/, $(PROGS))

.PHONY: clean prepare PROGS

all: prepare $(OBJPROG)

prepare:

clean:
	@rm -Rf $(OBJDIR)
	@rm -Rf $(BINDIR)

$(OBJPROG):	$(addprefix $(OBJDIR)/, $(OBJECTS))
	mkdir -p bin
	@echo "  BIN $@"
	$(GCC) -o $@ $(addprefix $(OBJDIR)/, $(OBJECTS)) $(LDFLAGS)
	@echo ""
	cp -f ${OBJDIR}/$(PROGS) ${BINDIR}

$(OBJDIR)/%.c.o : src/%.c
	mkdir -p obj
	echo "  CC  $<"
	$(GCC) $(C_FLAGS) $(C_INCLUDES) -c $< -o $@

