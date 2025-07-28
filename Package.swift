// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "hyperliquidExchange",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "hyperliquidExchange",
            targets: ["hyperliquidExchange"]),
    ],
    dependencies: [
        .package(url: "https://github.com/mathwallet/web3swift", exact: "3.5.0"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", exact: "5.9.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "hyperliquidExchange",
            dependencies: ["web3swift", "Alamofire"]
        ),
        .testTarget(
            name: "hyperliquidExchangeTests",
            dependencies: ["hyperliquidExchange"]
        ),
    ]
)
