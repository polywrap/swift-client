# Polywrap Client Documentation

Welcome to the Polywrap Client documentation. This documentation provides a detailed overview of the functionality and usage of the Polywrap Client library.


This package allows interaction with the WRAP Protocol. It is a Swift implementation of a [Polywrap Client](https://docs.polywrap.io/clients)

## Installation

PolywrapClient is available through Swift Package Manager and Cocoapods.

### Via Cocoapods

Add pod to your Podfile:

```Ruby
pod 'PolywrapClient'
```

### Via Xcode Menu

To add Polywrap Client as an SPM package to your project in Xcode you must do: File -> Swift Packages -> Add Package Dependency. And then enter https://github.com/polywrap/swift-client

### Via Package file

Add it as a dependency within your Package.swift manifest:

```swift
let package = Package(
    ...
    dependencies: [
        .package(url: "https://github.com/polywrap/swift-client.git", from: "0.0.3")
    ],
    ...
)
```

Then import PolywrapClient wherever you’d like to use it:

```swift
import PolywrapClient
```
    
## Getting Started

To get started, you will need to create a Config Builder instance which will allow you to configure the PolywrapClient instance. Then you can just call the `build` method of the `BuilderConfig` and get and instance of the client.

Once you have the instance of the client, you can invoke any WRAP by passing the URI and the method name. Optionally, you can also provide args and environment variables.

```swift
import PolywrapClient

// Create a Config Builder instance
let builder = BuilderConfig()

// Create a PolywrapClient instance with the builder
let client = builder.build()

// Invoke any method by passing URI and method name
let result: String = try client.invoke(uri: "wrap/some-uri", method: "someMethod")

// Or if you'd like to pass args and environment variables
let result: String = try client.invoke(uri: "wrap/some-uri", method: "coolMethod", args: someCodableStructInstance, env: anotherCodableStructInstace)

```

If you'd like to see which wraps are available, please refer to: https://www.wrapscan.io/

## Feedback and Support

If you encounter any bugs or have suggestions, feel free to create an issue on the repository. We would also love to hear from you if you have any feedback or general questions about the library.
