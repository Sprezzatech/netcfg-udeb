CC		= gcc
TARGETS		?= netcfg-dhcp netcfg-static netcfg

LDOPTS		= -ldebconfclient -ldebian-installer -liw
CFLAGS		= -W -Wall
COMMON_OBJS	= netcfg-common.o mii-lite.o wireless.o

ifneq (,$(findstring debug,$(DEB_BUILD_OPTIONS)))
CFLAGS += -O0 -g3
else
CFLAGS += -Os -fomit-frame-pointer
endif

all: $(TARGETS)

netcfg-dhcp: netcfg-dhcp.o dhcp.o
netcfg-static: netcfg-static.o static.o
netcfg: netcfg.o dhcp.o static.o

$(TARGETS): $(COMMON_OBJS)
	$(CC) -o $@ $^ $(LDOPTS)

%.o: %.c
	$(CC) -c $(CFLAGS) $(DEFS) $(INCS) -o $@ $<

clean:
	rm -f $(TARGETS) *.o

.PHONY: all clean
