// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ChristmasDesktopBuddy",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "ChristmasDesktopBuddy",
            targets: ["ChristmasDesktopBuddy"]
        )
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "ChristmasDesktopBuddy",
            dependencies: [],
            path: "ChristmasDesktopBuddy/Sources",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
