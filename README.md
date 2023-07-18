# Swift Client [![codecov](https://codecov.io/gh/polywrap/swift-client/branch/main/graph/badge.svg?token=JvNaa0OHjc)](https://codecov.io/gh/polywrap/swift-client)

Implementation of a client compatible with the [WRAP Protocol](https://github.com/polywrap/specification) in Swift

## Installation

PolywrapClient is available through Swift Package Manager. To install it into a project, add it as a dependency within your Package.swift manifest:

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

## Usage

Here's an example of how you could use the `PolywrapClient` class:

```swift
import PolywrapClient

// Create a Config Builder instance
let builder = BuilderConfig()

// Create a PolywrapClient instance with the builder
let client = builder.build()

// Invoke any method by passing URI and method name
let result: String = try client.invoke(uri: "wrap/cool-uri", method: "coolMethod")
```

## Contributions

Contributions to PolywrapClient are more than welcome. If you find a bug or have suggestions for improvements, please open an issue. And if you'd like to contribute code, we would be happy to review a pull request!