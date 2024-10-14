// swift-tools-version:5.8

import PackageDescription

// Version number can be found in Source/Danger/Danger.swift

// switch to false when release
let isDevelop = false

let swiftLint: Package.Dependency = {
    #if compiler(>=5.9)
    return .package(url: "https://github.com/Realm/SwiftLint", from: "0.56.0")
    #else
    return .package(url: "https://github.com/Realm/SwiftLint", exact: "0.53.0")
    #endif
}()

let devProducts: [Product] = isDevelop
    ? [
        .library(name: "DangerDeps", type: .dynamic, targets: ["Danger-Swift"])
    ] : []
let devDependencies: [Package.Dependency] = isDevelop
    ? [
        .package(url: "https://github.com/shibapm/Komondor", from: "1.1.4"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.54.0"),
        swiftLint,
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.17.0"),
        .package(url: "https://github.com/shibapm/Rocket", from: "1.3.0"),
    ] : []
let devTargets: [Target] = isDevelop
    ? [
        .testTarget(name: "DangerTests",
                    dependencies: [
                        "Danger",
                        "DangerFixtures",
                        .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
                    ]),
        .testTarget(name: "RunnerLibTests",
                    dependencies: [
                        "RunnerLib",
                        .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
        ], exclude: ["__Snapshots__"]),
        .testTarget(name: "DangerDependenciesResolverTests",
                    dependencies: [
                        "DangerDependenciesResolver",
                        .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
                    ],
                    exclude: ["__Snapshots__"]),
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
        .package(url: "https://github.com/mxcl/Version", from: "2.0.1"),
        .package(url: "https://github.com/nerdishbynature/octokit.swift", from: "0.13.0"),
    ] + devDependencies,
    targets: [
        .target(name: "Danger-Swift", dependencies: ["Danger"]),
        .target(name: "DangerShellExecutor"),
        .target(name: "DangerDependenciesResolver", dependencies: ["DangerShellExecutor", "Version", "Logger"]),
        .target(
            name: "Danger",
            dependencies: [
                .product(name: "OctoKit", package: "octokit.swift"),
                "Logger",
                "DangerShellExecutor"
            ]
        ),
        .target(name: "RunnerLib", dependencies: ["Logger", "DangerShellExecutor", "Version"]),
        .executableTarget(name: "Runner", dependencies: ["RunnerLib", "Logger", "DangerDependenciesResolver"]),
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
                "Scripts/change_is_develop.sh false",
                "git_add",
                "commit",
                "tag",
                "push",
                "Scripts/change_is_develop.sh true",
                "git_add",
                ["commit": ["message": "Enable dev depdendencies"]],
                "push",
                "Scripts/create_homebrew_tap.sh",
            ],
        ],
    ]).write()
#endif
