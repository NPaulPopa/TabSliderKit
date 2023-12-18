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
        
        .package(url: "https://github.com/NPaulPopa/MiniItemBasket.git", branch: "main"),
        
        .package(url: "https://github.com/NPaulPopa/FloatingButton.git", branch: "main"),
        
    ],
    targets: [
        .target(name: "TabBarSlider",dependencies: [
        
            .productItem(name: "MiniItemBasket", package: "MiniItemBasket", condition: nil),
            .productItem(name: "FloatingButton", package: "FloatingButton", condition: nil),
        ]),
        
        .testTarget(name: "TabBarSliderTests",dependencies: ["TabBarSlider"]),
    ]
)
