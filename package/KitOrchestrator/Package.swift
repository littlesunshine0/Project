// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "KitOrchestrator",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "KitOrchestrator", targets: ["KitOrchestrator"])
    ],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(
            name: "KitOrchestrator",
            dependencies: ["DataKit"],
            resources: [.process("Resources")]
        )
        //,
       // .testTarget(name: "KitOrchestratorTests", dependencies: ["KitOrchestrator"])
    ]
)
