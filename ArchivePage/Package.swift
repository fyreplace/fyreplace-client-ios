// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "ArchivePage",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(
            name: "ArchivePage",
            targets: ["ArchivePage"]
        ),
    ],
    dependencies: [
        .package(path: "../PostPage"),
        .package(path: "../ItemsListKit"),
    ],
    targets: [
        .target(
            name: "ArchivePage",
            dependencies: [
                .byName(name: "PostPage"),
                .byName(name: "ItemsListKit"),
            ]
        ),
    ]
)
