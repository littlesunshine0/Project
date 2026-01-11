// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "AssetKit",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "AssetKit", targets: ["AssetKit"])
    ],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(
            name: "AssetKit",
            dependencies: ["DataKit"],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "AssetKitTests", dependencies: ["AssetKit"])
    ]
)
