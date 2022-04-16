// swift-tools-version:5.3

import PackageDescription

// Version number can be found in Source/Danger/Danger.swift

// switch to false when release
let isDevelop = true

let devProducts: [Product] = isDevelop
    ? [
        .library(name: "DangerDeps", type: .dynamic, targets: ["Danger-Swift"])
    ] : []
let devDependencies: [Package.Dependency] = isDevelop
    ? [
        .package(url: "https://github.com/shibapm/Komondor", from: "1.1.3"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.49.4"),
        .package(url: "https://github.com/Realm/SwiftLint", from: "0.46.2"),
        .package(name: "SnapshotTesting", url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.7.1"),
        .package(url: "https://github.com/shibapm/Rocket", from: "1.2.1"),
    ] : []
let devTargets: [Target] = isDevelop
    ? [
        .testTarget(name: "DangerTests", dependencies: ["Danger", "DangerFixtures", "SnapshotTesting"]),
        .testTarget(name: "RunnerLibTests", dependencies: ["RunnerLib", "SnapshotTesting"], exclude: ["__Snapshots__"]),
        .testTarget(name: "DangerDependenciesResolverTests", dependencies: ["DangerDependenciesResolver", "SnapshotTesting"], exclude: ["__Snapshots__"]),
    ]
    : []

let package = Package(
    name: "danger-swift",
    products: [
        .library(name: "Danger", targets: ["Danger"]),
        .library(name: "DangerFixtures", targets: ["DangerFixtures"]),
        .executable(name: "danger-swift", targets: ["Runner"]),
    ] + devProducts,
    dependencies: [
        .package(url: "https://github.com/shibapm/Logger", from: "0.1.0"),
        .package(url: "https://github.com/mxcl/Version", from: "2.0.0"),
        .package(name: "OctoKit", url: "https://github.com/nerdishbynature/octokit.swift", from: "0.11.0"),
    ] + devDependencies,
    targets: [
        .target(name: "Danger-Swift", dependencies: ["Danger"]),
        .target(name: "DangerShellExecutor"),
        .target(name: "DangerDependenciesResolver", dependencies: ["DangerShellExecutor", "Version", "Logger"]),
        .target(name: "Danger", dependencies: ["OctoKit", "Logger", "DangerShellExecutor"]),
        .target(name: "RunnerLib", dependencies: ["Logger", "DangerShellExecutor", "Version"]),
        .target(name: "Runner", dependencies: ["RunnerLib", "Logger", "DangerDependenciesResolver"]),
        .target(name: "DangerFixtures", dependencies: ["Danger"]),
    ] + devTargets
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
            "pre_release_checks": [
                "clean_git",
            ],
            "steps": [
                "Scripts/update_makefile.sh",
                "Scripts/update_danger_version.sh",
                "Scripts/update_changelog.sh",
                "git_add",
                "commit",
                "tag",
                "push",
                "Scripts/create_homebrew_tap.sh"
            ]
        ],
    ]).write()
#endif
