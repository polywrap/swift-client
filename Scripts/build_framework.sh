set -e # Helps to give error info

# Project paths
RUST_PROJ="/Users/cesar/dev/polywrap/rust-client/packages/native"
IOS_PROJ="/Users/cesar/dev/polywrap/swift/PolywrapClient"

LOCAL_UDL="src/polywrap_native.udl"
UDL_NAME="polywrap_native"
FRAMEWORK_NAME="PolywrapClientNative"
SWIFT_INTERFACE="PolywrapClientLib"

BUILD_PATH="${IOS_PROJ}/Frameworks/PolywrapClientNative.xcframework"

cd "$RUST_PROJ"

# Compile the rust
cargo build --target aarch64-apple-ios
cargo build --target aarch64-apple-ios-sim
cargo build --target x86_64-apple-ios

IOS_ARM64_FRAMEWORK="$BUILD_PATH/ios-arm64/$FRAMEWORK_NAME.framework"
IOS_SIM_FRAMEWORK="$BUILD_PATH/ios-arm64_x86_64-simulator/$FRAMEWORK_NAME.framework"

# Remove old files if they exist
rm -rf "$IOS_ARM64_FRAMEWORK/Headers"
rm -rf "$IOS_ARM64_FRAMEWORK/$FRAMEWORK_NAME.a"
rm -rf "$IOS_SIM_FRAMEWORK/Headers"
rm -rf "$IOS_SIM_FRAMEWORK/$FRAMEWORK_NAME.a"
rm -rf "$IOS_PROJ/Sources/PolywrapClient/include/${UDL_NAME}FFI.h"

rm -rf ../../target/universal.a
rm -rf include/ios/*

# Make dirs if it doesn't exist
mkdir -p include/ios

# UniFfi bindgen
cargo run --bin uniffi-bindgen generate "$LOCAL_UDL" --language swift --out-dir $IOS_PROJ/Sources/PolywrapClient/include/.cache

# Make fat lib for sims
lipo -create \
    "../../target/aarch64-apple-ios-sim/debug/lib${UDL_NAME}.a" \
    "../../target/x86_64-apple-ios/debug/lib${UDL_NAME}.a" \
    -output ../../target/universal.a

# Move headers
mkdir "$IOS_ARM64_FRAMEWORK/Headers"
cp "$IOS_PROJ/Sources/PolywrapClient/include/.cache/${UDL_NAME}FFI.h" \
    "$IOS_ARM64_FRAMEWORK/Headers/${UDL_NAME}FFI.h"

mkdir "$IOS_SIM_FRAMEWORK/Headers"
cp "$IOS_PROJ/Sources/PolywrapClient/include/.cache/${UDL_NAME}FFI.h" \
    "$IOS_SIM_FRAMEWORK/Headers/${UDL_NAME}FFI.h"

cp "$IOS_PROJ/Sources/PolywrapClient/include/.cache/${UDL_NAME}FFI.h" "$IOS_PROJ/Sources/PolywrapClient/include/${UDL_NAME}FFI.h"

# Move binaries
cp "../../target/aarch64-apple-ios/debug/lib${UDL_NAME}.a" \
    "$IOS_ARM64_FRAMEWORK/$FRAMEWORK_NAME.a"
cp ../../target/universal.a \
    "$IOS_SIM_FRAMEWORK/$FRAMEWORK_NAME.a"

# Move swift interface
sed "s/${UDL_NAME}FFI/$FRAMEWORK_NAME/g" "$IOS_PROJ/Sources/PolywrapClient/include/.cache/$UDL_NAME.swift" > "$IOS_PROJ/Sources/PolywrapClient/include/$SWIFT_INTERFACE.swift"

# Update include folder and remove unneeded files
rm -rf $IOS_PROJ/Sources/PolywrapClient/include/.cache
