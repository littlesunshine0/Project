// swift-tools-version: 5.9
// CommandKit - Command Parsing & Autocomplete System

import PackageDescription

let package = Package(
    name: "CommandKit",
    platforms: [.macOS(.v14), .iOS(.v17), .visionOS(.v1)],
    products: [.library(name: "CommandKit", targets: ["CommandKit"])],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(
            name: "CommandKit",
            dependencies: ["DataKit"],
            path: "Sources/CommandKit",
            resources: [.process("Resources")]
        ),
        .testTarget(name: "CommandKitTests", dependencies: ["CommandKit"], path: "Tests/CommandKitTests")
    ]
)
