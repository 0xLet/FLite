// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FLite",
    platforms: [
        .iOS("13.0"),
        .macOS("10.15")
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "FLite",
            targets: ["FLite"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.0.1"),
        .package(url: "https://github.com/vapor/sqlite-nio.git", from: "1.0.0"),
        .package(url: "https://github.com/vapor/sqlite-kit.git", from: "4.0.2"),
        .package(url: "https://github.com/vapor/fluent-kit.git", from: "1.7.3"),
        .package(url: "https://github.com/0xLeif/async-kit.git", .branch("master"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "FLite",
            dependencies: [
            .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
            .product(name: "SQLiteNIO", package: "sqlite-nio"),
            .product(name: "SQLiteKit", package: "sqlite-kit"),
            .product(name: "FluentKit", package: "fluent-kit"),
            .product(name: "AsyncKit", package: "async-kit")
        ]),
        .testTarget(
            name: "FLiteTests",
            dependencies: ["FLite"]),
    ]
)
