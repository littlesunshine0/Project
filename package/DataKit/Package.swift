// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DataKit",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "DataKit", targets: ["DataKit"])
    ],
    targets: [
        .target(name: "DataKit"),
        .testTarget(name: "DataKitTests", dependencies: ["DataKit"])
    ]
)
