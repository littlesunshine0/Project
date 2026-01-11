// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "CollaborationKit",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "CollaborationKit", targets: ["CollaborationKit"])
    ],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(
            name: "CollaborationKit",
            dependencies: ["DataKit"],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "CollaborationKitTests", dependencies: ["CollaborationKit"])
    ]
)
