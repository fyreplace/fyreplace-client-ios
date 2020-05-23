// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "HomePage",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(
            name: "HomePage",
            targets: ["HomePage"]
        ),
    ],
    dependencies: [
        .package(path: "../FyreplaceKit"),
    ],
    targets: [
        .target(
            name: "HomePage",
            dependencies: [
                .byName(name: "FyreplaceKit"),
            ]
        ),
    ]
)
