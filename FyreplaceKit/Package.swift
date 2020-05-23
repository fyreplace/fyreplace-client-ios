// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "FyreplaceKit",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(
            name: "FyreplaceKit",
            targets: ["FyreplaceKit"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/ReactiveX/RxSwift.git",
            .upToNextMajor(from: "5.1.1")
        ),
        .package(
            url: "https://github.com/RxSwiftCommunity/RxSwiftExt.git",
            .upToNextMajor(from: "5.2.0")
        ),
        .package(
            url: "https://github.com/SDWebImage/SDWebImage.git",
            .upToNextMajor(from: "5.8.0")
        ),
        .package(
            url: "https://github.com/SDWebImage/SDWebImageWebPCoder.git",
            .upToNextMajor(from: "0.6.1")
        ),
    ],
    targets: [
        .target(
            name: "FyreplaceKit",
            dependencies: [
                .byName(name: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .byName(name: "RxSwiftExt"),
                .byName(name: "SDWebImage"),
                .byName(name: "SDWebImageWebPCoder"),
            ]
        ),
    ]
)
