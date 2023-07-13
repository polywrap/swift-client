set -e # Helps to give error info

LOCAL_UDL="src/polywrap_native.udl"
UDL_NAME="polywrap_native"
FRAMEWORK_NAME="PolywrapClientNative"
SWIFT_INTERFACE="PolywrapClientNativeLib"

BUILD_PATH="${IOS_PROJ}/Frameworks/PolywrapClientNative.xcframework"

cd "$RUST_PROJ"

# Compile the rust
cargo build --target aarch64-apple-ios
cargo build --target aarch64-apple-ios-sim
cargo build --target x86_64-apple-ios
cargo build --target x86_64-apple-darwin # For macOS w/Intel
cargo build --target aarch64-apple-darwin # For macOS w/M1

IOS_ARM64_FRAMEWORK="$BUILD_PATH/ios-arm64"
IOS_SIM_FRAMEWORK="$BUILD_PATH/ios-simulator"
MACOS_FRAMEWORK="$BUILD_PATH/macos"

# Remove old files if they exist
rm -rf "$IOS_ARM64_FRAMEWORK/Headers/${UDL_NAME}FFI.h"
rm -rf "$IOS_ARM64_FRAMEWORK/$FRAMEWORK_NAME.a"
rm -rf "$IOS_SIM_FRAMEWORK/Headers/${UDL_NAME}FFI.h"
rm -rf "$IOS_SIM_FRAMEWORK/$FRAMEWORK_NAME.a"
rm -rf "$MACOS_FRAMEWORK/Headers/${UDL_NAME}FFI.h"
rm -rf "$MACOS_FRAMEWORK/$FRAMEWORK_NAME.a"

rm -rf ../../target/universal.a
rm -rf include/ios/*

# Make dirs if it doesn't exist
mkdir -p include/ios

# UniFfi bindgen
cargo run --bin uniffi-bindgen generate "$LOCAL_UDL" --language swift --out-dir $IOS_PROJ/Sources/PolywrapClient/.cache

# Make fat lib for sims
lipo -create \
    "../../target/aarch64-apple-ios-sim/debug/lib${UDL_NAME}.a" \
    "../../target/x86_64-apple-ios/debug/lib${UDL_NAME}.a" \
    -output ../../target/universal.a

# Make fat lib for mac
lipo -create \
    "../../target/aarch64-apple-darwin/debug/lib${UDL_NAME}.a" \
    "../../target/x86_64-apple-darwin/debug/lib${UDL_NAME}.a" \
    -output ../../target/universal_mac.a

# Move headers
mkdir "$IOS_ARM64_FRAMEWORK/Headers"
cp "$IOS_PROJ/Sources/PolywrapClient/.cache/${UDL_NAME}FFI.h" \
    "$IOS_ARM64_FRAMEWORK/Headers/${UDL_NAME}FFI.h"

mkdir "$IOS_SIM_FRAMEWORK/Headers"
cp "$IOS_PROJ/Sources/PolywrapClient/.cache/${UDL_NAME}FFI.h" \
    "$IOS_SIM_FRAMEWORK/Headers/${UDL_NAME}FFI.h"

mkdir "$MACOS_FRAMEWORK/Headers"
cp "$IOS_PROJ/Sources/PolywrapClient/.cache/${UDL_NAME}FFI.h" \
    "$MACOS_FRAMEWORK/Headers/${UDL_NAME}FFI.h"

# Move binaries
cp "../../target/aarch64-apple-ios/debug/lib${UDL_NAME}.a" \
    "$IOS_ARM64_FRAMEWORK/$FRAMEWORK_NAME.a"
cp ../../target/universal.a \
    "$IOS_SIM_FRAMEWORK/$FRAMEWORK_NAME.a"
cp "../../target/universal_mac.a" \
    "$MACOS_FRAMEWORK/$FRAMEWORK_NAME.a"

# Move swift interface
sed "s/${UDL_NAME}FFI/$FRAMEWORK_NAME/g" "$IOS_PROJ/Sources/PolywrapClient/.cache/$UDL_NAME.swift" > "$IOS_PROJ/Sources/PolywrapClient/$SWIFT_INTERFACE.swift"

# Update include folder and remove unneeded files
rm -rf $IOS_PROJ/Sources/PolywrapClient/.cache
