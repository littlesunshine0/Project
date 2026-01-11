// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SearchKit",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "SearchKit", targets: ["SearchKit"])
    ],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(
            name: "SearchKit",
            dependencies: ["DataKit"],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "SearchKitTests", dependencies: ["SearchKit"])
    ]
)
