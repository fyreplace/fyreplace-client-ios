// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Lib",
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
    ],
    targets: [
        .target(
            name: "Lib",
            dependencies: [
                "RxSwift",
                "RxCocoa",
                "RxSwiftExt",
            ]
        ),
    ]
)