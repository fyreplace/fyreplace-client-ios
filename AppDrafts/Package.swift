// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "AppDrafts",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(
            name: "AppDrafts",
            targets: ["AppDrafts"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AppDrafts",
            dependencies: []
        ),
    ]
)
