// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "AppArchive",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(
            name: "AppArchive",
            targets: ["AppArchive"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AppArchive",
            dependencies: []
        ),
    ]
)
