// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PolywrapClient",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "PolywrapClient",
            targets: ["PolywrapClient"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/nnabeyang/swift-msgpack", from: "0.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .systemLibrary(
                name: "Cpolywrap_ffi_c",
                path: "Sources/Cpolywrap_ffi_c",
                pkgConfig: nil,
                providers: nil
        ),
        .target(
            name: "PolywrapClient",
            dependencies: [
                "Cpolywrap_ffi_c",
                .product(name: "SwiftMsgpack", package: "swift-msgpack"),
            ],
            cSettings: [
                .headerSearchPath("Sources/Cpolywrap_ffi_c")
            ],
            linkerSettings: [
                .linkedLibrary("polywrap_ffi_c"),
                .unsafeFlags(["-LSources/Cpolywrap_ffi_c/polywrap_ffi_c.so"])
            ]
        ),
        .testTarget(
            name: "PolywrapClientTests",
            dependencies: ["PolywrapClient"]),
    ]
)
