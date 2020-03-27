// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "LibWildFyre",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(
            name: "LibWildFyre",
            targets: ["LibWildFyre"]
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
            name: "LibWildFyre",
            dependencies: [
                .byName(name: "Moya"),
                .product(name: "RxMoya", package: "Moya")
            ]
        ),
    ]
)
