// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ProjectScaffold",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "ProjectScaffold", targets: ["ProjectScaffold"])
    ],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(
            name: "ProjectScaffold",
            dependencies: ["DataKit"],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "ProjectScaffoldTests", dependencies: ["ProjectScaffold"])
    ]
)
