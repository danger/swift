#!/bin/sh

rm -rf .build

# Builds the runner and the framework that will be used by the Dangerfile.swift.
# Then copies both to the root of the repo.

swift build -c release --arch arm64 --arch x86_64

cp .build/apple/Products/Release/danger-swift .

cd Projects/Danger

xcodebuild archive -project Danger.xcodeproj -scheme Danger -sdk macosx -destination "generic/platform=macOS" -archivePath "archives/Danger.framework"

cd ../..

cp -r Projects/Danger/archives/Danger.framework.xcarchive/Products/Library/Frameworks/Danger.framework .

rm -rf Projects/Danger/archives