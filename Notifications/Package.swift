// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Notifications",
    products: [
        .library(
            name: "Notifications",
            targets: ["Notifications"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Notifications",
            dependencies: []),
    ]
)
