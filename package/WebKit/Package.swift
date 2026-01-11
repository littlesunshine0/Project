// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "WebKit",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "WebKit", targets: ["WebKit"])
    ],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(
            name: "WebKit",
            dependencies: ["DataKit"],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "WebKitTests", dependencies: ["WebKit"])
    ]
)
