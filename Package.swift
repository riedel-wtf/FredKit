// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FredKit",
    defaultLocalization: "en",
    platforms: [.iOS(.v15), .macOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "FredKit",
            targets: ["FredKit"])
    ],
    dependencies: [],
    
    targets: [
        .target(
            name: "FredKit",
            dependencies: []
        ),
        .testTarget(
            name: "FredKitTests",
            dependencies: ["FredKit"]),
    ]
)
