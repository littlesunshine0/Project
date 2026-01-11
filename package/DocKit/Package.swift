// swift-tools-version: 5.9
// DocKit - Documentation Generation System

import PackageDescription

let package = Package(
    name: "DocKit",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "DocKit", targets: ["DocKit"])
    ],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(name: "DocKit", dependencies: ["DataKit"], path: "Sources/DocKit", resources: [.process("Resources")]),
        .testTarget(name: "DocKitTests", dependencies: ["DocKit"], path: "Tests/DocKitTests")
    ]
)
