TOOL_NAME = danger-swift
LIB_NAME = libDanger.dylib
VERSION = 0.1.1

PREFIX = /usr/local
INSTALL_PATH = $(PREFIX)/bin/$(TOOL_NAME)
BUILD_PATH = .build/release/$(TOOL_NAME)
LIB_PATH = .build/release/$(LIB_NAME)
LIB_INSTALL_PATH = $(PREFIX)/lib/$(LIB_NAME)
TAR_FILENAME = $(TOOL_NAME)-$(VERSION).tar.gz

install: build
	mkdir -p $(PREFIX)/bin
	cp -f $(BUILD_PATH) $(INSTALL_PATH)
	cp -f $(LIB_PATH) $(LIB_INSTALL_PATH)

build:
	swift package clean
	swift build --disable-sandbox -c release -Xswiftc -static-stdlib

uninstall:
	rm -f $(INSTALL_PATH)

get_sha:
	wget https://github.com/danger/$(TOOL_NAME)/archive/$(VERSION).tar.gz -O $(TAR_FILENAME)
	shasum -a 256 $(TAR_FILENAME)
	rm $(TAR_FILENAME)
