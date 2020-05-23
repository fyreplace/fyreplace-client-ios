// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "WildFyreKit",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(
            name: "WildFyreKit",
            targets: ["WildFyreKit"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/Moya/Moya.git",
            .upToNextMajor(from: "14.0.0")
        ),
    ],
    targets: [
        .target(
            name: "WildFyreKit",
            dependencies: [
                .byName(name: "Moya"),
                .product(name: "RxMoya", package: "Moya"),
            ]
        ),
    ]
)
