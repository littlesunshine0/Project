// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "AppIdeaKit",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "AppIdeaKit", targets: ["AppIdeaKit"])
    ],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(
            name: "AppIdeaKit",
            dependencies: ["DataKit"],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "AppIdeaKitTests", dependencies: ["AppIdeaKit"])
    ]
)
