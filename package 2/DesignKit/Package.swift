// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "DesignKit",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "DesignKit", targets: ["DesignKit"])
    ],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(
            name: "DesignKit",
            dependencies: ["DataKit"],
            resources: [.process("Resources")]
        )
        //,
        //.testTarget(name: "DesignKitTests", dependencies: ["DesignKit"])
    ]
)
