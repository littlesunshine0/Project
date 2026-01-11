// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "UIKit",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "UIKit", targets: ["UIKit"])
    ],
    dependencies: [
        .package(path: "../DataKit")
    ],
    targets: [
        .target(
            name: "UIKit",
            dependencies: ["DataKit"],
            path: "Sources/UIKit"
        ),
        .testTarget(
            name: "UIKitTests",
            dependencies: ["UIKit"],
            path: "Tests/UIKitTests"
        )
    ]
)
