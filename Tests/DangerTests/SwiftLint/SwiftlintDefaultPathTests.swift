@testable import Danger
import XCTest

final class SwiftlintDefaultPathTests: XCTestCase {
    let package = "testPackage.swift"

    override func tearDown() {
        try? FileManager.default.removeItem(atPath: package)
        super.tearDown()
    }

    func testItReturnsTheSPMCommandIfThePackageContainsTheSwiftlintDependency() {
        givenAFakePackage(hasSwiftlintDep: true)

        XCTAssertEqual(SwiftLint.swiftlintDefaultPath(packagePath: package), "swift run swiftlint")
    }

    func testItReturnsTheSwiftlintCLICommandIfThePackageContainsTheSwiftlintDependency() {
        givenAFakePackage(hasSwiftlintDep: false)

        XCTAssertEqual(SwiftLint.swiftlintDefaultPath(packagePath: package), "swiftlint")
    }

    private func givenAFakePackage(hasSwiftlintDep: Bool) {
        try? """
        // swift-tools-version:4.2

        import PackageDescription

        // Version number can be found in Source/Danger/Danger.swift

        let package = Package(
        name: "danger-swift",
        products: [
            .library(name: "Danger", type: .dynamic, targets: ["Danger"]),
            .library(name: "DangerFixtures", type: .dynamic, targets: ["DangerFixtures"]),
            .executable(name: "danger-swift", targets: ["Runner"]),
        ],
        dependencies: [
            .package(url: "https://github.com/f-meloni/Logger", from: "0.1.0"),
            .package(url: "https://github.com/JohnSundell/Marathon", from: "3.1.0"),
            .package(url: "https://github.com/JohnSundell/ShellOut", from: "2.1.0"),
            .package(url: "https://github.com/nerdishbynature/octokit.swift", from: "0.9.0"),
            // Danger Plugins
            // Dev dependencies
            .package(url: "https://github.com/eneko/SourceDocs", from: "0.5.1"), // dev
            .package(url: "https://github.com/orta/Komondor", from: "1.0.0"), // dev
            .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.35.8"), // dev
            \(hasSwiftlintDep ? ".package(url: \"https://github.com/Realm/SwiftLint\", from: \"0.28.1\")" : "")
            .package(url: "https://github.com/f-meloni/Rocket", from: "0.4.0"), // dev
        ],
        targets: [
            .target(name: "Danger", dependencies: ["ShellOut", "OctoKit", "Logger"]),
            .target(name: "RunnerLib", dependencies: ["Logger", "ShellOut"]),
            .target(name: "Runner", dependencies: ["RunnerLib", "MarathonCore", "Logger"]),
            .target(name: "DangerFixtures", dependencies: ["Danger"]),
            .testTarget(name: "DangerTests", dependencies: ["Danger", "DangerFixtures"]),
            .testTarget(name: "RunnerLibTests", dependencies: ["RunnerLib"]),
        ])
        """.write(toFile: package, atomically: false, encoding: .utf8)
    }
}
