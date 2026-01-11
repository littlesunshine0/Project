// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "KnowledgeKit",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "KnowledgeKit", targets: ["KnowledgeKit"])
    ],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(
            name: "KnowledgeKit",
            dependencies: ["DataKit"],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "KnowledgeKitTests", dependencies: ["KnowledgeKit"])
    ]
)
