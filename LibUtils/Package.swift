// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "LibUtils",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "LibUtils",
            targets: ["LibUtils"]
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
        .package(path: "../LibWildFyre"),
    ],
    targets: [
        .target(
            name: "LibUtils",
            dependencies: [
                .byName(name: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .byName(name: "RxSwiftExt"),
                .byName(name: "LibWildFyre"),
            ]
        ),
    ]
)
