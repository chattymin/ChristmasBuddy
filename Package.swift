// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ChristmasBuddy",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "ChristmasBuddy",
            targets: ["ChristmasBuddy"]
        )
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "ChristmasBuddy",
            dependencies: [],
            path: "ChristmasBuddy/Sources",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
