TARGET:=main
#CROSS:=arm-none-eabi-
CROSS:=arm-linux-gnueabi-
CC:=$(CROSS)gcc
ECHO:=@

SSRC+=$(shell find . -name '*.s')
CSRC+=$(shell find . -name '*.c')
CPPSRC+=$(shell find . -name '*.cpp')
OBJS+=$(SSRC:%.s=%.o)
OBJS+=$(CSRC:%.c=%.o)
OBJS+=$(CPPSRC:%.cpp=%.o)

ALLPATHS:=$(shell ls -R | grep :)
CFLAGS+=$(ALLPATHS:%:=-I%)
CFLAGS+=-c -I. -DDEBUG -O0
CFLAGS+=-mcpu=cortex-a8 -mfloat-abi=soft -mfpu=vfpv3-d16 -fno-stack-protector
#CFLAGS+=-ffunction-sections -fdata-sections

CSFLAGS+=$(CFLAGS)
CCFLAGS+=$(CFLAGS) -std=gnu11
CCPPFLAGS+=$(CFLAGS) -std=gnu++11

LDFLAGS+=$(ALLPATHS:%:=-L%)
LDFLAGS+=-T./link.ld -nostartfiles -static
LDFLAGS+=-Wl,--build-id=none
#LDFLAGS+=-Wl,--gc-sections

.PHONY:all clean
all:$(TARGET).elf
	@echo -e '[33m[OD] [32m$< -> $(TARGET).dis[0m'
	@$(CROSS)objdump -D $< > $(TARGET).dis
	@echo -e '[33m[OC] [32m$< -> $(TARGET).bin[0m'
	@$(CROSS)objcopy -Obinary $< $(TARGET).bin
	@echo -e '[33m[MK] [32m$< -> u-boot.img[0m'
	@mkimage -A arm -T firmware -C none -O u-boot -a 0x80800000 -e 0 -d $< u-boot.img
$(TARGET).elf:$(OBJS)
	@echo -e '[33m[LD] [32m$^ -> $@[0m'
	$(ECHO)$(CC) -o $@ $^ $(LDFLAGS)
%.o:%.s
	@echo -e '[33m[CC] [32m$^ -> $@[0m'
	$(ECHO)$(CC) -o $@ $< $(CSFLAGS)
%.o:%.c
	@echo -e '[33m[CC] [32m$^ -> $@[0m'
	$(ECHO)$(CC) -o $@ $< $(CCFLAGS)
%.o:%.cpp
	@echo -e '[33m[CC] [32m$^ -> $@[0m'
	$(ECHO)$(CC) -o $@ $< $(CCPPFLAGS)
clean:
	@echo -e '[33m[RM] [32m$(TARGET) $(OBJS) cscope.* tags[0m'
	$(ECHO)rm -rf $(TARGET).elf $(OBJS) cscope.* tags *.bin *.img *.dis
