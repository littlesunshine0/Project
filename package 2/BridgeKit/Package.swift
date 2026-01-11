// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "BridgeKit",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "BridgeKit", targets: ["BridgeKit"])
    ],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(
            name: "BridgeKit",
            dependencies: ["DataKit"],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "BridgeKitTests", dependencies: ["BridgeKit"])
    ]
)
