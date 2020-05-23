// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "NotificationsPage",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(
            name: "NotificationsPage",
            targets: ["NotificationsPage"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "NotificationsPage",
            dependencies: []
        ),
    ]
)
