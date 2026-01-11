// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "NotificationKit",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "NotificationKit", targets: ["NotificationKit"])
    ],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(
            name: "NotificationKit",
            dependencies: ["DataKit"],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "NotificationKitTests", dependencies: ["NotificationKit"])
    ]
)
