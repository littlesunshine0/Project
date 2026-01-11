// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ParseKit",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "ParseKit", targets: ["ParseKit"])
    ],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(
            name: "ParseKit",
            dependencies: ["DataKit"],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "ParseKitTests", dependencies: ["ParseKit"])
    ]
)
