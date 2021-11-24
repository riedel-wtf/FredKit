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
        .package(url: "https://github.com/frogg/Charts.git", .branch("master"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        
        .target(
            name: "FredKit",
            dependencies: [
                .product(
                    name: "Charts",
                    package: "Charts",
                    condition: .when(platforms: [.iOS])
                ),
            ]),
        .testTarget(
            name: "FredKitTests",
            dependencies: ["FredKit"]),
    ]
)
