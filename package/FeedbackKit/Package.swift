// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "FeedbackKit",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "FeedbackKit", targets: ["FeedbackKit"])
    ],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(
            name: "FeedbackKit",
            dependencies: ["DataKit"],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "FeedbackKitTests", dependencies: ["FeedbackKit"])
    ]
)
