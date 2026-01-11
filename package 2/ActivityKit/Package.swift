// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ActivityKit",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "ActivityKit", targets: ["ActivityKit"])
    ],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(
            name: "ActivityKit",
            dependencies: ["DataKit"],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "ActivityKitTests", dependencies: ["ActivityKit"])
    ]
)
