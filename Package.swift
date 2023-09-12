// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TabBarSlider",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "TabBarSlider", targets: ["TabBarSlider"]),
    ],
    dependencies: [ ],
    targets: [
        .target(name: "TabBarSlider",dependencies: []),
        
        .testTarget(name: "TabBarSliderTests",dependencies: ["TabBarSlider"]),
    ]
)
