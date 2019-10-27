// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "AppSettings",
    products: [
        .library(
            name: "AppSettings",
            targets: ["AppSettings"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "AppSettings",
            dependencies: []),
    ]
)
