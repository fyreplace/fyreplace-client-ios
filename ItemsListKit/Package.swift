// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "ItemsListKit",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(
            name: "ItemsListKit",
            targets: ["ItemsListKit"]
        ),
    ],
    dependencies: [
        .package(path: "../FyreplaceKit"),
    ],
    targets: [
        .target(
            name: "ItemsListKit",
            dependencies: [
                .byName(name: "FyreplaceKit"),
            ]
        ),
    ]
)
