ZIG_VERSION  := 0.11.0-dev.987+a1d82352d
ZIG_BASE_URL := https://ziglang.org/builds
ZIG_LINUX    := zig-linux-x86_64-$(ZIG_VERSION)
ZIG_ARCHIVE  := $(ZIG_LINUX).tar.xz
ZIG_DOWNLOAD := $(ZIG_ARCHIVE)

ZIG_EXE := ./$(ZIG_LINUX)/zig

ZIG_OUT   := zig-out
ZIG_CACHE := zig-cache
ZIG_LIB   := $(ZIG_OUT)/lib

EXE     := $(ZIG_OUT)/bin/
SRC     := 
SRC     += $(wildcard src/*.zig)

CC      := $(ZIG_EXE) cc
CXX     := $(ZIG_EXE) c++
ZIG_TRANSLATE_C := $(ZIG_EXE) translate-c

CFLAGS := -I/usr/include
LDFLAGS := -fPIC -shared

all: $(ZIG_EXE) 

$(EXE): $(ZIG_OUT) $(ZIG_LIB) build.zig $(SRC)
	echo "zig build"
	@$(ZIG_EXE) build

$(ZIG_OUT):
	mkdir -p $(ZIG_OUT)

$(ZIG_LIB):
	mkdir -p $(ZIG_LIB)

$(ZIG_EXE): | $(ZIG_DOWNLOAD)
	tar -xf $(ZIG_DOWNLOAD)

$(ZIG_DOWNLOAD):
	wget $(ZIG_BASE_URL)/$(ZIG_DOWNLOAD) -O $(ZIG_DOWNLOAD)

dirclean: clean storeclean depclean
	$(RM) -f $(ZIG_DOWNLOAD)
	$(RM) -r $(ZIG_LINUX)

depclean: 

clean: $(EXE)
	@echo "zig clean"
	$(RM) -r $(ZIG_OUT)

run:
	@echo "zig build run"
	$(ZIG_EXE) build run

buildclean: depclean
	$(RM) -r $(ZIG_OUT)
	$(RM) -r $(ZIG_LIB)
	$(RM) -r $(ZIG_CACHE)

.PHONY: all clean dirclen buildclean run store depclean

# Don't echo commands unless the caller exports "V=1"
${V}.SILENT: