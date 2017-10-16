TOOL_NAME = danger-swift
VERSION = 0.1.0

PREFIX = /usr/local
INSTALL_PATH = $(PREFIX)/bin/$(TOOL_NAME)
BUILD_PATH = .build/release/$(TOOL_NAME)
TAR_FILENAME = $(TOOL_NAME)-$(VERSION).tar.gz

install: build
	mkdir -p $(PREFIX)/bin
	cp -f $(BUILD_PATH) $(INSTALL_PATH)

build:
	swift package clean
	swift build --disable-sandbox -c release -Xswiftc -static-stdlib

uninstall:
	rm -f $(INSTALL_PATH)

get_sha:
	wget https://github.com/danger/$(TOOL_NAME)/archive/$(VERSION).tar.gz -O $(TAR_FILENAME)
	shasum -a 256 $(TAR_FILENAME)
	rm $(TAR_FILENAME)
