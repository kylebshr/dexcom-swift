// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Dexcom",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "Dexcom",
            targets: ["Dexcom"]
        ),
    ],
    targets: [
        .target(
            name: "Dexcom"
        ),
        .testTarget(
            name: "DexcomTests",
            dependencies: ["Dexcom"]
        ),
    ]
)
