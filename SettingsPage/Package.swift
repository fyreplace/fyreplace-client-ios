// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "SettingsPage",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(
            name: "SettingsPage",
            targets: ["SettingsPage"]
        ),
    ],
    dependencies: [
        .package(path: "../FyreplaceKit"),
    ],
    targets: [
        .target(
            name: "SettingsPage",
            dependencies: [
                .byName(name: "FyreplaceKit"),
            ]
        ),
    ]
)
