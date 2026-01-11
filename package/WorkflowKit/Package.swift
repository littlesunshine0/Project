// swift-tools-version: 5.9
// WorkflowKit - Workflow Orchestration & Execution System

import PackageDescription

let package = Package(
    name: "WorkflowKit",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "WorkflowKit",
            targets: ["WorkflowKit"]
        )
    ],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(
            name: "WorkflowKit",
            dependencies: ["DataKit"],
            path: "Sources/WorkflowKit",
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "WorkflowKitTests",
            dependencies: ["WorkflowKit"],
            path: "Tests/WorkflowKitTests"
        )
    ]
)
