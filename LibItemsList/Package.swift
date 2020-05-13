// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "LibItemsList",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(
            name: "LibItemsList",
            targets: ["LibItemsList"]
        ),
    ],
    dependencies: [
        .package(path: "../Lib"),
    ],
    targets: [
        .target(
            name: "LibItemsList",
            dependencies: [
                .byName(name: "Lib"),
            ]
        ),
    ]
)
