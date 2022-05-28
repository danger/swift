#!/bin/bash

lower () {
    IFS='.' read -a v1_array <<< "$1"
    IFS='.' read -a v2_array <<< "$2"
    v1=$((v1_array[0] * 100 + v1_array[1] * 10 + v1_array[2]))
    v2=$((v2_array[0] * 100 + v2_array[1] * 10 + v2_array[2]))
    diff=$((v2 - v1))

    ((diff >  0)) && return 0
    return 1
}

TOOL_NAME="danger-swift"
PREFIX=${PREFIX:='/usr/local'}
INSTALL_PATH="$PREFIX/bin/$TOOL_NAME"
BUILD_PATH=".build/release/$TOOL_NAME"
LIB_INSTALL_PATH="$PREFIX/lib/danger"
declare -a SWIFT_LIB_FILES=('libDanger.dylib' 'libDanger.so' 'Danger.swiftdoc' 'Danger.swiftmodule' 'OctoKit.swiftdoc' 'OctoKit.swiftmodule' 'RequestKit.swiftdoc' 'RequestKit.swiftmodule' 'Logger.swiftdoc' 'Logger.swiftmodule' 'DangerShellExecutor.swiftdoc' 'DangerShellExecutor.swiftmodule')


DANGER_LIB_DECLARATION='\.library(name:\ \"Danger\", targets: \[\"Danger\"\])'
DANGER_LIB_DYNAMIC_DECLARATION='\.library(name:\ \"Danger\",\ type:\ \.dynamic,\ targets:\ \[\"Danger\"\])'
sed  "s/$DANGER_LIB_DECLARATION/$DANGER_LIB_DYNAMIC_DECLARATION/g" Package.swift > tmpPackage
mv -f tmpPackage Package.swift

swift package clean

SWIFT_VERSION=`swift -version | head -n 1 | perl -lpe 's/.*version\ (\d\.\d\.\d).*/$1/'`

UNAME_OUT="$(uname -s)"

lower $SWIFT_VERSION '5.3.0'

if [[ "$?" -eq 0 || "$OSTYPE" == "darwin"* ]]
then
    BUILD_FOLDER=".build/release"
    if [[ `uname -m` == 'arm64' ]]; then
        swift build --disable-sandbox --arch x86_64 -c release
    else
        swift build --disable-sandbox -c release
    fi
else
    BUILD_FOLDER=".build/debug"
    swift build --disable-sandbox
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