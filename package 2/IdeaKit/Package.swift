// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "IdeaKit",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "IdeaKit", targets: ["IdeaKit"])
    ],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(
            name: "IdeaKit",
            dependencies: ["DataKit"],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "IdeaKitTests", dependencies: ["IdeaKit"])
    ]
)
