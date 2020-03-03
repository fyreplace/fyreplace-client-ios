// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "AppSettings",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(
            name: "AppSettings",
            targets: ["AppSettings"]
        ),
    ],
    dependencies: [
        .package(path: "../Lib"),
    ],
    targets: [
        .target(
            name: "AppSettings",
            dependencies: [
                "Lib",
            ]
        ),
    ]
)
