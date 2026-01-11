// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ErrorKit",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "ErrorKit", targets: ["ErrorKit"])
    ],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(
            name: "ErrorKit",
            dependencies: ["DataKit"],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "ErrorKitTests", dependencies: ["ErrorKit"])
    ]
)
