# Use musl cross compiler for AArch64
CC ?= aarch64-linux-musl-gcc

SOURCES = $(patsubst src/%, %, $(wildcard src/*.c))
SOURCES += device/main.c device/i_fb_video.c device/i_no_sound.c device/i_no_music.c
OBJECTS = $(patsubst %.c, %.o, $(SOURCES))
TARGET_OBJS = $(patsubst %, build/%, $(OBJECTS))

# PIE + dynamic link, no static, musl compatible
CCFLAGS = -DNORMALUNIX -std=gnu99 -fPIE
LDFLAGS = -pie

.PHONY: all
all: doom

.PHONY: sources
sources:
	@echo $(SOURCES)

.PHONY: objects
objects:
	@echo $(TARGET_OBJS)

build:
	mkdir -p build/device

build/%.o: src/%.c | build
	@echo "Compiling $<..."
	$(CC) -c $< -I src $(CCFLAGS) -g -o $@

build/device/%.o: device/%.c | build
	@echo "Compiling $<..."
	$(CC) -c $< -I src $(CCFLAGS) -g -o $@

.PHONY: link
link: $(TARGET_OBJS)
	@echo "Linking..."
	$(CC) -o doom $(TARGET_OBJS) $(LDFLAGS)

doom: link
