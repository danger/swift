lower () {
    IFS=. 
    declare -a v1_array=($1) 
    declare -a v2_array=($2)
    v1=$((v1_array[0] * 100 + v1_array[1] * 10 + v1_array[2]))
    v2=$((v2_array[0] * 100 + v2_array[1] * 10 + v2_array[2]))
    diff=$((v2 - v1))

    ((diff >  0)) && return 0
    return 1
}

TOOL_NAME="danger-swift"
PREFIX="/usr/local"
INSTALL_PATH="$PREFIX/bin/$TOOL_NAME"
BUILD_PATH=".build/release/$TOOL_NAME"
LIB_INSTALL_PATH="$PREFIX/lib/danger"
declare -a SWIFT_LIB_FILES=('libDanger.dylib' 'libDanger.so' 'Danger.swiftdoc' 'Danger.swiftmodule' 'OctoKit.swiftdoc' 'OctoKit.swiftmodule' 'RequestKit.swiftdoc' 'RequestKit.swiftmodule' 'Logger.swiftdoc' 'Logger.swiftmodule' 'DangerShellExecutor.swiftdoc' 'DangerShellExecutor.swiftmodule')

swift package clean

SWIFT_VERSION=`swift -version | head -n 1 | perl -lpe 's/.*version\ (\d\.\d\.\d).*/$1/'`

lower $SWIFT_VERSION '5.3.0'

if [[ "$?" -eq 0 ]]
then
    BUILD_FOLDER=".build/release"
    swift build --disable-sandbox -c release
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