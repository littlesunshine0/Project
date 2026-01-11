// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SystemKit",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "SystemKit", targets: ["SystemKit"])
    ],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(
            name: "SystemKit",
            dependencies: ["DataKit"],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "SystemKitTests", dependencies: ["SystemKit"])
    ]
)
