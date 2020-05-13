// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "FoundationExtensions",
    platforms: [.iOS(.v12), .macOS(.v10_15), .tvOS(.v13), .watchOS(.v6)],
    products: [
        .library(name: "FoundationExtensions", targets: ["FoundationExtensions"])
    ],
    dependencies: [],
    targets: [
        .target(name: "FoundationExtensions", dependencies: []),
        .testTarget(name: "FoundationExtensionsTests", dependencies: ["FoundationExtensions"])
    ]
)
