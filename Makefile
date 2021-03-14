TOOL_NAME = danger-swift
# Get this from the Danger.swift someday

PREFIX = /usr/local
INSTALL_PATH = $(PREFIX)/bin/$(TOOL_NAME)

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

install:
	Scripts/install.sh


uninstall:
	rm -f $(INSTALL_PATH)
