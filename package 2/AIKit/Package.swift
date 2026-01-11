// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "AIKit",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "AIKit", targets: ["AIKit"])
    ],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(
            name: "AIKit",
            dependencies: ["DataKit"],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "AIKitTests", dependencies: ["AIKit"])
    ]
)
