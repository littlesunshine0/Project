// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ChatKit",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "ChatKit", targets: ["ChatKit"])
    ],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(
            name: "ChatKit",
            dependencies: ["DataKit"],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "ChatKitTests", dependencies: ["ChatKit"])
    ]
)
