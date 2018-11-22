TOOL_NAME = danger-swift
# Get this from the Danger.swift someday
VERSION = 0.7.0

PREFIX = /usr/local
INSTALL_PATH = $(PREFIX)/bin/$(TOOL_NAME)
BUILD_PATH = .build/release/$(TOOL_NAME)
LIB_INSTALL_PATH = $(PREFIX)/lib/danger

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

deploy:
	if [[ -z "$(NEW_VERSION)" ]]; then echo "Please add a value to the NEW_VERSION variable"; exit 1; fi
	export NEW_VERSION=$(NEW_VERSION)
	export TOOL_NAME=$(TOOL_NAME)
	`Scripts/update_makefile.sh`
	`Scripts/update_danger_version.sh`
	`Scripts/update_changelog.sh`
	`Scripts/commit_new_version.sh`
	`Scripts/create_homebrew_tap.sh`
