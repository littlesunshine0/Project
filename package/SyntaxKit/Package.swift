// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SyntaxKit",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "SyntaxKit", targets: ["SyntaxKit"])
    ],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(
            name: "SyntaxKit",
            dependencies: ["DataKit"],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "SyntaxKitTests", dependencies: ["SyntaxKit"])
    ]
)
