#!/bin/bash

# Change to the Examples directory
cd Example

pod install

# Loop through each directory inside Examples
for example in */; do
    # Remove trailing slash to get just the directory name
    exampleName=${example%/}

    # Skip example.xcworkspace & Pods directory
    if [ "$exampleName" == "example.xcworkspace" ] || [ "$exampleName" == "Pods" ]; then
        continue
    fi

    # Also skip ethers example because it can only be run in m1 simulators (due to metamask sdk)
    # and gh action does not support that out of the box
    if [ "$exampleName" == "Ethers" ]; then
        continue
    fi

    # Now, run xcodebuild for each example
    xcodebuild -workspace example.xcworkspace -scheme $exampleName -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 14,OS=16.2' clean build CODE_SIGNING_ALLOWED=NO
done