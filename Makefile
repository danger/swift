TOOL_NAME = danger-swift
# Get this from the Danger.swift someday
VERSION = 3.4.1

PREFIX = /usr/local
INSTALL_PATH = $(PREFIX)/bin/$(TOOL_NAME)
BUILD_PATH = .build/release/$(TOOL_NAME)
LIB_INSTALL_PATH = $(PREFIX)/lib/danger

SWIFT_LIB_FILES = .build/release/libDanger.* .build/release/Danger.swiftdoc .build/release/Danger.swiftmodule .build/release/OctoKit.swiftdoc .build/release/OctoKit.swiftmodule .build/release/RequestKit.swiftdoc .build/release/RequestKit.swiftmodule .build/release/Logger.swiftdoc .build/release/Logger.swiftmodule .build/release/DangerShellExecutor.swiftdoc .build/release/DangerShellExecutor.swiftmodule

docs: 
	swift run swift-doc generate Sources/Danger --module-name Danger --output Documentation/reference --format html
	./Scripts/update_docs.rb

version:
	Scripts/update_makefile.sh
	Scripts/update_danger_version.sh
	Scripts/update_changelog.sh

deploy_tap:
	Scripts/create_homebrew_tap.sh

install: build
	mkdir -p $(PREFIX)/bin
	mkdir -p $(LIB_INSTALL_PATH)
	cp -f $(BUILD_PATH) $(INSTALL_PATH)
	cp -fr $(SWIFT_LIB_FILES) $(LIB_INSTALL_PATH)

build:
	swift package clean
	swift build --disable-sandbox -c release

uninstall:
	rm -f $(INSTALL_PATH)
