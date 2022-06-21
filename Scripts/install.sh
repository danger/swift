#!/bin/bash

TOOL_NAME="danger-swift"
PREFIX=${PREFIX:='/usr/local'}
INSTALL_PATH="$PREFIX/bin/$TOOL_NAME"
BUILD_PATH=".build/release/$TOOL_NAME"
LIB_INSTALL_PATH="$PREFIX/lib/danger"
declare -a SWIFT_LIB_FILES=('libDanger.dylib' 'libDanger.so' 'Danger.swiftdoc' 'Danger.swiftmodule' 'OctoKit.swiftdoc' 'OctoKit.swiftmodule' 'RequestKit.swiftdoc' 'RequestKit.swiftmodule' 'Logger.swiftdoc' 'Logger.swiftmodule' 'DangerShellExecutor.swiftdoc' 'DangerShellExecutor.swiftmodule')


DANGER_LIB_DECLARATION='\.library(name:\ \"Danger\", targets: \[\"Danger\"\])'
DANGER_LIB_DYNAMIC_DECLARATION='\.library(name:\ \"Danger\",\ type:\ \.dynamic,\ targets:\ \[\"Danger\"\])'
sed "s/$DANGER_LIB_DECLARATION/$DANGER_LIB_DYNAMIC_DECLARATION/g" Package.swift > tmpPackage
mv -f tmpPackage Package.swift

swift package clean

BUILD_FOLDER=".build/release"
swift build --disable-sandbox -c release

if [ $? -ne 0 ]; then
    echo '[WARN] Failed to install with `release` configuration. Try to install with `debug` configuration.'
    BUILD_FOLDER=".build/debug"
    swift build --disable-sandbox -c debug
fi

ARRAY=()
for ARG in "${SWIFT_LIB_FILES[@]}"; do
    ARRAY+=("$BUILD_FOLDER/$ARG")
done

mkdir -p "$PREFIX/bin"
mkdir -p "$LIB_INSTALL_PATH"
cp -f "$BUILD_FOLDER/$TOOL_NAME" "$INSTALL_PATH"
cp -fr "${ARRAY[@]}" "$LIB_INSTALL_PATH" 2>/dev/null || :

sed -e "s/$DANGER_LIB_DYNAMIC_DECLARATION/$DANGER_LIB_DECLARATION/g" Package.swift > tmpPackage
mv -f tmpPackage Package.swift