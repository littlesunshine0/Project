// swift-tools-version: 5.9
// AgentKit - Autonomous Agent System

import PackageDescription

let package = Package(
    name: "AgentKit",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "AgentKit",
            targets: ["AgentKit"]
        )
    ],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(
            name: "AgentKit",
            dependencies: ["DataKit"],
            path: "Sources/AgentKit",
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "AgentKitTests",
            dependencies: ["AgentKit"],
            path: "Tests/AgentKitTests"
        )
    ]
)
