// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "IconKit",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "IconKit", targets: ["IconKit"])
    ],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(
            name: "IconKit",
            dependencies: ["DataKit"],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "IconKitTests", dependencies: ["IconKit"])
    ]
)
