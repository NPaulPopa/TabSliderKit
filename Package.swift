// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TabBarSlider",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "TabBarSlider", targets: ["TabBarSlider"]),
    ],
    dependencies: [
        .package(name: "MiniItemBasket", path: "../MiniItemBasket"),
        .package(name: "FloatingButton", path: "../FloatingButton"),
        .package(name: "Extensions", path: "../Extensions"),

    ],
    targets: [
        .target(name: "TabBarSlider",dependencies: [
        
            .productItem(name: "MiniItemBasket", package: "MiniItemBasket", condition: nil),
            .productItem(name: "FloatingButton", package: "FloatingButton", condition: nil),
            .productItem(name: "Extensions", package: "Extensions", condition: nil),
        ]),
        
        .testTarget(name: "TabBarSliderTests",dependencies: ["TabBarSlider"]),
    ]
)
