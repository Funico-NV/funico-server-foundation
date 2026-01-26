// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "funico-server-foundation",
    products: [
        .library(name: "ServerFoundation", targets: ["ServerFoundation"])
    ],
    targets: [
        .target(
            name: "ServerFoundation"
        ),
        .testTarget(
            name: "ServerFoundationTests",
            dependencies: ["ServerFoundation"]
        )
    ]
)
