// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ExportKit",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "ExportKit", targets: ["ExportKit"])
    ],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(
            name: "ExportKit",
            dependencies: ["DataKit"],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "ExportKitTests", dependencies: ["ExportKit"])
    ]
)
