// swift-tools-version: 5.9.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NadaADeclarar",
    platforms: [
        .macOS(.v12) // Update this line
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "NadaADeclarar",
            targets: ["NadaADeclarar"]),
    ],
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint.git", from: .init(0, 55, 0))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "NadaADeclarar",
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")
            ]),
        .testTarget(
            name: "NadaADeclararTests",
            dependencies: ["NadaADeclarar"],
            resources: [.process("Resources")]),
    ]
)
