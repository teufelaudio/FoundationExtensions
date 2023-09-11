// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "FoundationExtensions",
    platforms: [.iOS(.v13), .macOS(.v10_15), .tvOS(.v13), .watchOS(.v6)],
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
