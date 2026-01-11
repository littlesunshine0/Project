// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MarketplaceKit",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "MarketplaceKit", targets: ["MarketplaceKit"])
    ],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(
            name: "MarketplaceKit",
            dependencies: ["DataKit"],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "MarketplaceKitTests", dependencies: ["MarketplaceKit"])
    ]
)
