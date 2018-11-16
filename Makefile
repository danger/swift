TOOL_NAME = danger-swift
# Get this from the Danger.swift someday
VERSION = 0.6.0

PREFIX = /usr/local
INSTALL_PATH = $(PREFIX)/bin/$(TOOL_NAME)
BUILD_PATH = .build/release/$(TOOL_NAME)
LIB_INSTALL_PATH = $(PREFIX)/lib/danger
TAR_FILENAME = $(TOOL_NAME)-$(VERSION).tar.gz

SWIFT_LIB_FILES = .build/release/libDanger.* .build/release/Danger.swiftdoc .build/release/Danger.swiftmodule .build/release/ShellOut.swiftmodule .build/release/ShellOut.swiftdoc .build/release/OctoKit.swiftdoc .build/release/OctoKit.swiftmodule .build/release/RequestKit.swiftdoc .build/release/RequestKit.swiftmodule .build/release/Logger.swiftdoc .build/release/Logger.swiftmodule

install: build
	mkdir -p $(PREFIX)/bin
	mkdir -p $(PREFIX)/lib/danger
	cp -f $(BUILD_PATH) $(INSTALL_PATH)
	cp -f $(SWIFT_LIB_FILES) $(LIB_INSTALL_PATH)

build:
	swift package clean
	swift build --disable-sandbox -c release --static-swift-stdlib

uninstall:
	rm -f $(INSTALL_PATH)

get_sha:
	wget https://github.com/danger/$(TOOL_NAME)/archive/$(VERSION).tar.gz -O $(TAR_FILENAME)
	shasum -a 256 $(TAR_FILENAME)
	rm $(TAR_FILENAME)
