// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "LibWildFyre",
    platforms: [
        .iOS(.v10),
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
            .upToNextMajor(from: "14.0.0-beta.6")
        ),
    ],
    targets: [
        .target(
            name: "LibWildFyre",
            dependencies: [
                "Moya",
                "RxMoya",
            ]
        ),
    ]
)
