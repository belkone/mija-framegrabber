CROSS_COMPILE ?=arm-linux-gnueabihf-
GCC ?= $(CROSS_COMPILE)gcc

C_FLAGS := -w -O2 -std=gnu99 -march=armv7-a -fPIC -DPIC -DOMXILCOMPONENTSPATH=\"/$(BUILD_DIR)\" -DCONFIG_DEBUG_LEVEL=255
C_INCLUDES := -I./include

LDFLAGS := -L./lib/$(MODEL) $(LIBS) $(DYNAMICLINKER)

PROGS = framegrabber

C_SRCS=$(wildcard ./src/*.c)
C_SRCS_NO_DIR=$(notdir $(C_SRCS))
OBJECTS=$(patsubst %.c, %.c.o,  $(C_SRCS_NO_DIR))

OBJDIR=$(shell pwd)/obj/$(MODEL)
BINDIR=$(shell pwd)/bin/$(MODEL)

OBJPROG=$(addprefix $(OBJDIR)/, $(PROGS))

.PHONY: clean prepare PROGS

all: ipc009 ipc016 ipc019

prepare:

ipc009:
	@ \
	MODEL=ipc009 \
	LIBS="-lev -lshbf -lshbfev -lc-2.25 -lpthread-2.25 -lrt-2.25" \
	$(MAKE) expand

ipc016:
	@ \
	MODEL=ipc016 \
	LIBS="-lev -l:libshbf.so.0.2 -l:libshbfev.so.0.2 -lc-2.25 -lpthread-2.25 -lrt-2.25" \
	$(MAKE) expand

ipc019:
	@ \
	MODEL=ipc019 \
	CROSS_COMPILE=/home/osboxes/buildroot-2020.02.1/output/host/bin/arm-buildroot-linux-uclibcgnueabihf- \
	LIBS="-lev -l:libshbf.so.0.2 -l:libshbfev.so.0.2 -l:ld-uClibc.so.1 -luClibc-1.0.26" \
	DYNAMICLINKER="-Wl,--dynamic-linker=/lib/ld-uClibc.so.0" \
	$(MAKE) expand

expand: $(OBJPROG)

clean:
	@rm -Rf $(OBJDIR)
	@rm -Rf $(BINDIR)

$(OBJPROG):	$(addprefix $(OBJDIR)/, $(OBJECTS))
	mkdir -p $(BINDIR)
	@echo "  BIN $@"
	$(GCC) -o $@ $(addprefix $(OBJDIR)/, $(OBJECTS)) $(LDFLAGS)
	@echo ""
	cp -f ${OBJDIR}/$(PROGS) ${BINDIR}

$(OBJDIR)/%.c.o : src/%.c
	mkdir -p $(OBJDIR)
	echo "  CC  $<"
	$(GCC) $(C_FLAGS) $(C_INCLUDES) -c $< -o $@

