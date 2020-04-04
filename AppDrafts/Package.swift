// swift-tools-version:5.2

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
    dependencies: [
        .package(path: "../Lib"),
    ],
    targets: [
        .target(
            name: "AppDrafts",
            dependencies: [
                .byName(name: "Lib"),
            ]
        ),
    ]
)
