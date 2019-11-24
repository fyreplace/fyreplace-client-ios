// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "LibCommon",
    platforms: [
        .iOS(.v10),
    ],
    products: [
        .library(
            name: "LibCommon",
            targets: ["LibCommon"]
        ),
    ],
    dependencies: [
        .package(path: "../Lib"),
        .package(path: "../LibWildFyre"),
    ],
    targets: [
        .target(
            name: "LibCommon",
            dependencies: [
                "Lib",
                "LibWildFyre",
            ]
        ),
    ]
)
