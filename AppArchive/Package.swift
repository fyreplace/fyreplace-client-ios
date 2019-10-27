// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "AppArchive",
    products: [
        .library(
            name: "AppArchive",
            targets: ["AppArchive"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "AppArchive",
            dependencies: []),
    ]
)
