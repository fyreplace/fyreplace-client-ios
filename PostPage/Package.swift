// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "PostPage",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(
            name: "PostPage",
            targets: ["PostPage"]
        ),
    ],
    dependencies: [
        .package(path: "../FyreplaceKit"),
        .package(path: "../MarkdownKit"),
    ],
    targets: [
        .target(
            name: "PostPage",
            dependencies: [
                .byName(name: "FyreplaceKit"),
                .byName(name: "MarkdownKit"),
            ]
        ),
    ]
)
