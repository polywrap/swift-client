// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PolywrapClient",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "PolywrapClient",
            targets: ["PolywrapClient", "PolywrapClientNative"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/hirotakan/MessagePacker.git", from: "0.4.7")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "PolywrapClient",
            dependencies: ["MessagePacker"],
            exclude: ["Resources/wrappers"],
            publicHeadersPath: "Resources/include",
            cSettings: [ .headerSearchPath("Resources/include") ]
        ),
        .binaryTarget(
            name: "PolywrapClientNative",
            path: "Frameworks/PolywrapClientNative.xcframework"
        ),
        .testTarget(
            name: "PolywrapClientTests",
            dependencies: [
                "PolywrapClient"
            ],
            resources: [.copy("Resources/wrappers")], // This line is added
            cSettings: [ .headerSearchPath("../../Sources/PolywrapClient/Resources/include")]
        )
    ]
)
