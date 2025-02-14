// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "edf2csv",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
        .package(url: "https://github.com/p-x9/swift-edf.git", from: "0.2.0")
    ],
    targets: [
        .executableTarget(
            name: "edf2csv",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "EDF", package: "swift-edf")
            ]
        ),
    ]
)
