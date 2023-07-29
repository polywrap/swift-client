// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PolywrapClient",
    platforms: [.iOS(.v13), .macOS(.v10_15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "PolywrapClient",
            targets: ["PolywrapClient", "PolywrapClientNative"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/hirotakan/MessagePacker.git", from: "0.4.7"),
        .package(url: "https://github.com/SwiftyLab/AsyncObjects.git", from: "2.1.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "PolywrapClient",
            dependencies: ["MessagePacker", "PolywrapClientNative", "AsyncObjects"],
            path: "Source"
        ),
        .binaryTarget(
            name: "PolywrapClientNative",
            url: "https://github.com/polywrap/swift-client/releases/download/v0.0.5/PolywrapClientNative.xcframework.zip",
            checksum: "94d60176a86f143ee0eab32255fcdcf886c9af747fc4abd42459958a2f830beb"
        ),
        .testTarget(
            name: "PolywrapClientTests",
            dependencies: [
                "PolywrapClient"
            ],
            path: "Tests",
            resources: [ .copy("Cases") ]
        )
    ]
)
