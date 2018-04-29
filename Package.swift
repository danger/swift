// swift-tools-version:4.0

import PackageDescription

// Version number can be found in Source/Danger/Danger.swift

let package = Package(
    name: "danger-swift",
    products: [
        .library(name: "Danger", type: .dynamic, targets: ["Danger"]),
        .executable(name: "danger-swift", targets: ["Runner"])
    ],
    dependencies: [
        .package(url: "https://github.com/JohnSundell/Marathon.git", from: "3.0.0"),
    ],
    targets: [
        .target(name: "Danger", dependencies: []),
        .target(name: "Runner", dependencies: ["Danger", "MarathonCore"]),
        .testTarget(name: "DangerTests", dependencies: ["Danger"]),
    ],
    swiftLanguageVersions: [4]
)
