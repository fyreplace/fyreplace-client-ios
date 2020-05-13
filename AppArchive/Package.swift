// swift-tools-version:5.2

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
    dependencies: [
        .package(path: "../LibItemsList"),
    ],
    targets: [
        .target(
            name: "AppArchive",
            dependencies: [
                .byName(name: "LibItemsList"),
            ]
        ),
    ]
)
