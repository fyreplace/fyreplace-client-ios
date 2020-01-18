// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Lib",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "Lib",
            targets: ["Lib"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/ReactiveX/RxSwift.git",
            .upToNextMajor(from: "5.0.1")
        ),
        .package(
            url: "https://github.com/RxSwiftCommunity/RxSwiftExt.git",
            .upToNextMajor(from: "5.2.0")
        ),
        .package(
            url: "https://github.com/SDWebImage/SDWebImage.git",
            .upToNextMajor(from: "5.5.0")
        ),
        .package(
            url: "https://github.com/SDWebImage/SDWebImageWebPCoder.git",
            .upToNextMajor(from: "0.5.0")
        ),
        .package(path: "../LibWildFyre"),
    ],
    targets: [
        .target(
            name: "Lib",
            dependencies: [
                "RxSwift",
                "RxCocoa",
                "RxSwiftExt",
                "SDWebImage",
                "SDWebImageWebPCoder",
                "LibWildFyre",
            ]
        ),
    ]
)
