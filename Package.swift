// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FredKit",
    defaultLocalization: "en",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "FredKit",
            targets: ["FredKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/frogg/FredKitCharts.git", .upToNextMajor(from: "4.0.1"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        
        .target(
            name: "FredKit",
            dependencies: [
                .product(
                    name: "Charts",
                    package: "FredKitCharts",
                    condition: .when(platforms: [.iOS])
                ),
            ]),
        .testTarget(
            name: "FredKitTests",
            dependencies: ["FredKit"]),
    ]
)
