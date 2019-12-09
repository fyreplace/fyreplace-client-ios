// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "AppSettings",
    platforms: [
        .iOS(.v10),
    ],
    products: [
        .library(
            name: "AppSettings",
            targets: ["AppSettings"]
        ),
    ],
    dependencies: [
        .package(path: "../LibCommon"),
    ],
    targets: [
        .target(
            name: "AppSettings",
            dependencies: [
                "LibCommon",
            ]
        ),
    ]
)
