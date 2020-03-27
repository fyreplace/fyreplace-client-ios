// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Lib",
    platforms: [
        .iOS(.v11)
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
            .upToNextMajor(from: "5.6.1")
        ),
        .package(
            url: "https://github.com/SDWebImage/SDWebImageWebPCoder.git",
            .upToNextMajor(from: "0.5.0")
        ),
        .package(path: "../LibUtils"),
    ],
    targets: [
        .target(
            name: "Lib",
            dependencies: [
                .byName(name: "SDWebImage"),
                .byName(name: "SDWebImageWebPCoder"),
                .byName(name: "LibUtils"),
            ]
        ),
    ]
)
