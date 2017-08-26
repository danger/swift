// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Danger",
    products: [
        .library(name: "Danger", type: .dynamic, targets: ["Danger"]),
        .executable(name: "danger-swift", targets: ["Runner"])
    ],
    targets: [
        .target(name: "Danger", dependencies: []),
        .target(name: "Runner", dependencies: ["Danger"]),
        .testTarget(name: "DangerTests", dependencies: ["Danger"])
    ],
    swiftLanguageVersions: [3]
)
