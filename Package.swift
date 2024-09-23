// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "FoundationExtensions",
    platforms: [.iOS(.v17), .macOS(.v14), .tvOS(.v17), .watchOS(.v8)],
    products: [
        .library(name: "FoundationExtensions", targets: ["FoundationExtensions"]),
        .library(name: "FoundationExtensionsDynamic", type: .dynamic, targets: ["FoundationExtensions"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "FoundationExtensions",
            dependencies: [
            ]
        ),
        .target(
            name: "FoundationExtensionsDynamic",
            dependencies: [
            ]
        ),
        .testTarget(
            name: "FoundationExtensionsTests",
            dependencies: [
                "FoundationExtensions"
            ]
        )
    ]
)
