// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "NLUKit",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "NLUKit", targets: ["NLUKit"])
    ],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(
            name: "NLUKit",
            dependencies: ["DataKit"],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "NLUKitTests", dependencies: ["NLUKit"])
    ]
)
