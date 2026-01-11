// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "IndexerKit",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "IndexerKit", targets: ["IndexerKit"])
    ],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(
            name: "IndexerKit",
            dependencies: ["DataKit"],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "IndexerKitTests", dependencies: ["IndexerKit"])
    ]
)
