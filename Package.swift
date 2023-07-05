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
            targets: ["PolywrapClient", "PolywrapClientNative"]),
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
            publicHeadersPath: "include",
            cSettings: [ .headerSearchPath("include") ]
        ),
        .binaryTarget(
            name: "PolywrapClientNative",
            path: "Frameworks/PolywrapClientNative.xcframework"
            // url: "https://github.com/polywrap/swift-client/releases/download/v0.0.1/PolywrapClientNative.xcframework.zip",
            // checksum: "da1b45242f3a9194e23b4f2a595ea8d5b3d9cc912a201066c8b56deedd52d34a"
        ),
        .testTarget(
            name: "PolywrapClientTests",
            dependencies: [
                "PolywrapClient",
            ],
            resources: [ .copy("Cases") ],
            cSettings: [ .headerSearchPath("../../Sources/PolywrapClient/include")]
        )
    ]
)
