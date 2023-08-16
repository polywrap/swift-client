![polywrap-banner](https://raw.githubusercontent.com/polywrap/branding/master/assets/banner.png)

# Swift Client  [![codecov](https://codecov.io/gh/polywrap/swift-client/branch/main/graph/badge.svg?token=JvNaa0OHjc)](https://codecov.io/gh/polywrap/swift-client)


Implementation of the Polywrap client in Swift.

## Installation

PolywrapClient is available through Swift Package Manager and Cocoapods.

#### Via Cocoapods

Add pod to your Podfile:

```Ruby
pod 'PolywrapClient'
```

#### Via Xcode Menu

To add Polywrap Client as an SPM package to your project in Xcode you must do: File -> Swift Packages -> Add Package Dependency. And then enter https://github.com/polywrap/swift-client

#### Via Package file

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

## Getting started

Create a new Polywrap Client Config Builder instance, add the bundles you want to use, and then create a new Polywrap Client instance from the builder.

```swift
import PolywrapClient

struct CatArgs: Codable {
    var cid: String
    var ipfsProvider: String
}

func main() throws {
    let client = BuilderConfig()
        .addSystemDefault()
        .build()

    let catResult: Data = try client.invoke(
        uri: try Uri("wrapscan.io/polywrap/ipfs-http-client@1.0"),
        method: "cat",
        args: CatArgs(
            cid: resolveResult.cid,
            ipfsProvider: resolveResult.provider
        )
    )

    print(catResult)
}
```

## Resources

- [Documentation](https://docs.polywrap.io/)
- [Examples](./Example)
- [Features supported](https://github.com/polywrap/client-readiness/tree/main/clients/swift/Sources/Readiness/Features)
- [Support](https://discord.polywrap.io)

## Contributions

Please check out our [contributing guide](./CONTRIBUTING.md) for guidelines about how to proceed.