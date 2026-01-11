// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "AnalyticsKit",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "AnalyticsKit", targets: ["AnalyticsKit"])
    ],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(
            name: "AnalyticsKit",
            dependencies: ["DataKit"],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "AnalyticsKitTests", dependencies: ["AnalyticsKit"])
    ]
)
