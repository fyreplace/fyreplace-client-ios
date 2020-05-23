// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "DraftsPage",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(
            name: "DraftsPage",
            targets: ["DraftsPage"]
        ),
    ],
    dependencies: [
        .package(path: "../FyreplaceKit"),
    ],
    targets: [
        .target(
            name: "DraftsPage",
            dependencies: [
                .byName(name: "FyreplaceKit"),
            ]
        ),
    ]
)
