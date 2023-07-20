set -e # Helps to give error info

xcodebuild clean docbuild -scheme PolywrapClient -derivedDataPath ./BuiltDocs -destination 'platform=macOS'
$(xcrun --find docc) process-archive transform-for-static-hosting ./BuiltDocs/Build/Products/Debug/PolywrapClient.doccarchive --hosting-base-path swift-client --output-path docs/