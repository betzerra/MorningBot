// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MorningBot",
    platforms: [
         .macOS(.v12),
    ],
    dependencies: [
        .package(url: "git@github.com:betzerra/Clarinete.git", exact: .init(1, 0, 0)),
        .package(url: "git@github.com:betzerra/OpenWeather.git", exact: .init(0, 2, 2)),
        .package(url: "git@github.com:rapierorg/telegram-bot-swift.git", exact: .init(2, 1, 2))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "MorningBot",
            dependencies: [
                "Clarinete",
                "OpenWeather",
                .product(name: "TelegramBotSDK", package: "telegram-bot-swift")
            ],
            resources: [
                .process("Resources/config.json")
            ]
        ),
        .testTarget(
            name: "MorningBotTests",
            dependencies: ["MorningBot"]),
    ]
)
