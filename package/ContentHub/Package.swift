// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ContentHub",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "ContentHub", targets: ["ContentHub"])
    ],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(
            name: "ContentHub",
            dependencies: ["DataKit"],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "ContentHubTests", dependencies: ["ContentHub"])
    ]
)
