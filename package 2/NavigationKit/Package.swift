// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "NavigationKit",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "NavigationKit", targets: ["NavigationKit"])
    ],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(
            name: "NavigationKit",
            dependencies: ["DataKit"],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "NavigationKitTests", dependencies: ["NavigationKit"])
    ]
)
