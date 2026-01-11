// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "LearnKit",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "LearnKit", targets: ["LearnKit"])
    ],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(
            name: "LearnKit",
            dependencies: ["DataKit"],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "LearnKitTests", dependencies: ["LearnKit"])
    ]
)
