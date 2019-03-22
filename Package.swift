// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "localize",
    dependencies: [
        .package(url: "https://github.com/tadija/AEXML.git", from: "4.3.3")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "localize",
            dependencies: ["AEXML"]),
        .testTarget(
            name: "localizeTests",
            dependencies: ["localize"]),
    ]
)
