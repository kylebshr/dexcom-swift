// swift-tools-version: 6.0

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
            name: "Dexcom",
            swiftSettings: [
                .swiftLanguageMode(.v6),
            ]
        ),
        .testTarget(
            name: "DexcomTests",
            dependencies: ["Dexcom"],
            swiftSettings: [
                .swiftLanguageMode(.v6),
            ]
        ),
    ]
)
