// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "UserKit",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "UserKit", targets: ["UserKit"])
    ],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(
            name: "UserKit",
            dependencies: ["DataKit"],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "UserKitTests", dependencies: ["UserKit"])
    ]
)
