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
        .package(url: "https://github.com/JohnSundell/Marathon.git", from: "3.1.0"),
        .package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.1.0"),
        .package(url: "https://github.com/f-meloni/octokit.swift", .branch("add_objc_imports"))
    ],
    targets: [
        .target(name: "Danger", dependencies: ["ShellOut", "OctoKit"]),
        .target(name: "Runner", dependencies: ["Danger", "MarathonCore"]),
        .testTarget(name: "DangerTests", dependencies: ["Danger"]),
    ],
    swiftLanguageVersions: [4]
)
