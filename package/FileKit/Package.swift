// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "FileKit",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "FileKit", targets: ["FileKit"])
    ],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(
            name: "FileKit",
            dependencies: ["DataKit"],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "FileKitTests", dependencies: ["FileKit"])
    ]
)
