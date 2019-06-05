// swift-tools-version:5.0

import PackageDescription

// Version number can be found in Source/Danger/Danger.swift

let package = Package(
    name: "danger-swift",
    products: [
        .library(name: "Danger", type: .dynamic, targets: ["Danger"]),
        .library(name: "DangerFixtures", type: .dynamic, targets: ["DangerFixtures"]),
        .library(name: "DangerDeps", type: .dynamic, targets: ["Danger-Swift"]), // dev
        .executable(name: "danger-swift", targets: ["Runner"]),
    ],
    dependencies: [
        .package(url: "https://github.com/shibapm/Logger", from: "0.1.0"),
        .package(url: "https://github.com/JohnSundell/Marathon", from: "3.2.0"),
        // Danger Plugins
        // Dev dependencies
        .package(url: "https://github.com/shibapm/Komondor", from: "1.0.0"), // dev
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.35.8"), // dev
        .package(url: "https://github.com/Realm/SwiftLint", from: "0.28.1"), // dev
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.0.0"), // dev
        .package(url: "https://github.com/shibapm/Rocket", from: "0.4.0"), // dev
        .package(url: "https://github.com/jpsim/Yams.git", from: "1.0.0"), // dev
        .package(url: "https://github.com/eneko/SourceDocs", from: "0.5.1"), // dev
    ],
    targets: [
        .target(name: "Danger-Swift", dependencies: ["Danger", "Yams"]), // dev
        .target(name: "DangerShellExecutor"),
        .target(name: "Danger", dependencies: ["Logger", "DangerShellExecutor"]),
        .target(name: "RunnerLib", dependencies: ["Logger", "DangerShellExecutor"]),
        .target(name: "Runner", dependencies: ["RunnerLib", "MarathonCore", "Logger"]),
        .target(name: "DangerFixtures", dependencies: ["Danger"]),
        .testTarget(name: "DangerTests", dependencies: ["Danger", "DangerFixtures", "SnapshotTesting"]), // dev
        .testTarget(name: "RunnerLibTests", dependencies: ["RunnerLib", "SnapshotTesting"]), // dev
    ]
)

#if canImport(PackageConfig)
    import PackageConfig

    let config = PackageConfiguration([
        "komondor": [
            "pre-push": "swift test",
            "pre-commit": [
                "swift test",
                "swift test --generate-linuxmain",
                "swift run swiftformat .",
                "swift run swiftlint autocorrect --path Sources/",
                "git add .",
            ],
        ],
        "rocket": [
            "before": [
                "make docs",
                "Scripts/update_makefile.sh",
                "Scripts/update_danger_version.sh",
                "Scripts/update_changelog.sh",
            ],
            "after": [
                "Scripts/create_homebrew_tap.sh",
            ],
        ],
    ]).write()
#endif
