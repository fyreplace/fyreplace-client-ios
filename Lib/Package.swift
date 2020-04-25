// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Lib",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(
            name: "Lib",
            targets: ["Lib"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/SDWebImage/SDWebImage.git",
            .upToNextMajor(from: "5.7.3")
        ),
        .package(path: "../LibUtils"),
    ],
    targets: [
        .target(
            name: "Lib",
            dependencies: [
                .byName(name: "SDWebImage"),
                .byName(name: "LibUtils"),
            ]
        ),
    ]
)
