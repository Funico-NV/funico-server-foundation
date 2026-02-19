// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "funico-server-foundation",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(name: "ServerFoundation", targets: ["ServerFoundation"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.91.1")
    ],
    targets: [
        .target(
            name: "ServerFoundation",
            dependencies: [
                .product(name: "Vapor", package: "vapor")
            ]
        ),
        .testTarget(
            name: "ServerFoundationTests",
            dependencies: ["ServerFoundation"]
        )
    ]
)
