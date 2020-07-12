// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "MarkdownKit",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(
            name: "MarkdownKit",
            targets: ["MarkdownKit"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MarkdownKit",
            dependencies: [],
            path: "Sources/MarkdownKit"
        ),
    ]
)
