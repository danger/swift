@testable import Danger
import DangerFixtures
import XCTest

class DangerSwiftLintTests: XCTestCase {
    var executor: FakeShellExecutor!
    var fakePathProvider: FakeCurrentPathProvider!
    var danger: DangerDSL!
    var markdownMessage: String?

    override func setUp() {
        executor = FakeShellExecutor()
        fakePathProvider = FakeCurrentPathProvider()
        fakePathProvider.currentPath = "/Users/ash/bin"

        danger = githubFixtureDSL
        markdownMessage = nil
    }

    func testExecutesTheShell() {
        _ = SwiftLint.lint(danger: danger, shellExecutor: executor, swiftlintPath: "swiftlint", currentPathProvider: fakePathProvider)
        XCTAssertNotEqual(executor.invocations.dropFirst().count, 0)
        XCTAssertEqual(executor.invocations.first?.command, "swiftlint")
    }

    func testExecutesTheShellWithCustomSwiftLintPath() {
        _ = SwiftLint.lint(danger: danger, shellExecutor: executor, swiftlintPath: "Pods/SwiftLint/swiftlint", currentPathProvider: fakePathProvider)
        XCTAssertNotEqual(executor.invocations.dropFirst().count, 0)
        XCTAssertEqual(executor.invocations.first?.command, "Pods/SwiftLint/swiftlint")
    }

    func testExecuteSwiftLintInInlineMode() {
        mockViolationJSON()
        var warns = [(String, String, Int)]()
        let warnAction: (String, String, Int) -> Void = { warns.append(($0, $1, $2)) }
        var fails = [(String, String, Int)]()
        let failAction: (String, String, Int) -> Void = { fails.append(($0, $1, $2)) }

        _ = SwiftLint.lint(danger: danger, shellExecutor: executor, swiftlintPath: "swiftlint", inline: true, currentPathProvider: fakePathProvider, failInlineAction: failAction, warnInlineAction: warnAction)

        XCTAssertEqual(warns.first?.0, "Opening braces should be preceded by a single space and on the same line as the declaration. (opening_brace)")
        XCTAssertEqual(warns.first?.1, "SomeFile.swift")
        XCTAssertEqual(warns.first?.2, 8)

        XCTAssertEqual(fails.first?.0, "Line should be 120 characters or less: currently 211 characters (line_length)")
        XCTAssertEqual(fails.first?.1, "AnotherFile.swift")
        XCTAssertEqual(fails.first?.2, 10)
    }

    func testExecutesSwiftLintWithConfigWhenPassed() {
        let configFile = "/Path/to/config/.swiftlint.yml"

        _ = SwiftLint.lint(danger: danger, shellExecutor: executor, swiftlintPath: "swiftlint", configFile: configFile, currentPathProvider: fakePathProvider)

        let swiftlintCommands = executor.invocations.filter { $0.command == "swiftlint" }
        XCTAssertTrue(swiftlintCommands.count > 0)
        swiftlintCommands.forEach { _, arguments in
            XCTAssertTrue(arguments.contains("--config \"\(configFile)\""))
        }
    }

    func testExecutesSwiftLintWithDirectoryPassed() {
        let directory = "Tests"
        let modified = [
            "Tests/SomeFile.swift",
            "Harvey/SomeOtherFile.swift",
            "Test Dir/SomeThirdFile.swift",
            "circle.yml",
        ]
        danger = githubWithFilesDSL(created: [], modified: modified, deleted: [], fileMap: [:])

        _ = SwiftLint.lint(danger: danger, shellExecutor: executor, swiftlintPath: "swiftlint", directory: directory, currentPathProvider: fakePathProvider)

        let swiftlintCommands = executor.invocations.filter { $0.command == "swiftlint" }
        XCTAssertEqual(swiftlintCommands.count, 1)
        XCTAssertTrue(swiftlintCommands.first!.arguments.contains("--path \"Tests/SomeFile.swift\""))
    }

    func testExecutesSwiftLintWhenLintingAllFiles() {
        let modified = [
            "Tests/SomeFile.swift",
            "Harvey/SomeOtherFile.swift",
            "Test Dir/SomeThirdFile.swift",
            "circle.yml",
        ]
        danger = githubWithFilesDSL(created: [], modified: modified, deleted: [], fileMap: [:])

        _ = SwiftLint.lint(danger: danger, shellExecutor: executor, swiftlintPath: "swiftlint", lintAllFiles: true, currentPathProvider: fakePathProvider)

        let swiftlintCommands = executor.invocations.filter { $0.command == "swiftlint" }
        XCTAssertEqual(swiftlintCommands.count, 1)
        XCTAssertFalse(swiftlintCommands.first!.arguments.contains("--path"))
    }

    func testExecutesSwiftLintWhenLintingAllFilesWithDirectoryPassed() {
        let directory = "Tests"
        let modified = [
            "Tests/SomeFile.swift",
            "Harvey/SomeOtherFile.swift",
            "Test Dir/SomeThirdFile.swift",
            "circle.yml",
        ]
        danger = githubWithFilesDSL(created: [], modified: modified, deleted: [], fileMap: [:])

        _ = SwiftLint.lint(danger: danger, shellExecutor: executor, swiftlintPath: "swiftlint", directory: directory, lintAllFiles: true, currentPathProvider: fakePathProvider)

        let swiftlintCommands = executor.invocations.filter { $0.command == "swiftlint" }
        XCTAssertEqual(swiftlintCommands.count, 1)
        XCTAssertFalse(swiftlintCommands.first!.arguments.contains("--path \"Tests/SomeFile.swift\""))
        XCTAssertTrue(swiftlintCommands.first!.arguments.contains("--path \"Tests\""))
    }

    func testFiltersOnSwiftFiles() {
        _ = SwiftLint.lint(danger: danger, shellExecutor: executor, swiftlintPath: "swiftlint", currentPathProvider: fakePathProvider)

        let quoteCharacterSet = CharacterSet(charactersIn: "\"")
        let filesExtensions = Set(executor.invocations.dropFirst().compactMap { $0.arguments[2].split(separator: ".").last?.trimmingCharacters(in: quoteCharacterSet) })
        XCTAssertEqual(filesExtensions, ["swift"])
    }

    func testPrintsNoMarkdownIfNoViolations() {
        _ = SwiftLint.lint(danger: danger, shellExecutor: executor, swiftlintPath: "swiftlint", currentPathProvider: fakePathProvider)
        XCTAssertNil(markdownMessage)
    }

    func testViolations() {
        let modified = [
            "Tests/SomeFile.swift",
            "Harvey/SomeOtherFile.swift",
            "circle.yml",
        ]
        danger = githubWithFilesDSL(created: [], modified: modified, deleted: [], fileMap: [:])
        mockViolationJSON()

        let violations = SwiftLint.lint(danger: danger, shellExecutor: executor, swiftlintPath: "swiftlint", currentPathProvider: fakePathProvider, markdownAction: writeMarkdown)
        XCTAssertEqual(violations.count, 4) // Two files, one (identical oops) violation returned for each.
    }

    func testMarkdownReporting() {
        mockViolationJSON()
        _ = SwiftLint.lint(danger: danger, shellExecutor: executor, swiftlintPath: "swiftlint", currentPathProvider: fakePathProvider, markdownAction: writeMarkdown)
        XCTAssertNotNil(markdownMessage)
        XCTAssertTrue(markdownMessage!.contains("SwiftLint found issues"))
        XCTAssertTrue(markdownMessage!.contains("Opening braces should be preceded by a single space and on the same line as the declaration. (opening_brace)")) // swiftlint:disable:this line_length
    }

    func testQuotesPathArguments() {
        let modified = [
            "Tests/SomeFile.swift",
            "Harvey/SomeOtherFile.swift",
            "Test Dir/SomeThirdFile.swift",
            "circle.yml",
        ]
        danger = githubWithFilesDSL(created: [], modified: modified, deleted: [], fileMap: [:])

        _ = SwiftLint.lint(danger: danger, shellExecutor: executor, swiftlintPath: "swiftlint", currentPathProvider: fakePathProvider)

        let swiftlintCommands = executor.invocations.filter { $0.command == "swiftlint" }

        XCTAssertTrue(swiftlintCommands.count > 0)

        let spacedDirSwiftlintCommands = swiftlintCommands.filter { _, arguments in
            arguments.contains("--path \"Test Dir/SomeThirdFile.swift\"")
        }

        XCTAssertEqual(spacedDirSwiftlintCommands.count, 1)
    }

    func mockViolationJSON() {
        executor.output = """
        [
            {
                "rule_id" : "opening_brace",
                "reason" : "Opening braces should be preceded by a single space and on the same line as the declaration.",
                "character" : 39,
                "file" : "/Users/ash/bin/SomeFile.swift",
                "severity" : "Warning",
                "type" : "Opening Brace Spacing",
                "line" : 8
            },
            {
                "rule_id" : "line_length",
                "reason" : "Line should be 120 characters or less: currently 211 characters",
                "character" : null,
                "file" : "/Users/ash/bin/AnotherFile.swift",
                "severity" : "Error",
                "type" : "Line Length",
                "line" : 10
            }
        ]
        """
    }

    func writeMarkdown(_ message: String) {
        markdownMessage = message
    }

    static var allTests = [
        ("testExecutesTheShell", testExecutesTheShell),
        ("testExecutesSwiftLintWithConfigWhenPassed", testExecutesSwiftLintWithConfigWhenPassed),
        ("testExecutesSwiftLintWithDirectoryPassed", testExecutesSwiftLintWithDirectoryPassed),
        ("testExecutesSwiftLintWhenLintingAllFiles", testExecutesSwiftLintWhenLintingAllFiles),
        ("testExecutesSwiftLintWhenLintingAllFilesWithDirectoryPassed", testExecutesSwiftLintWhenLintingAllFilesWithDirectoryPassed),
        ("testFiltersOnSwiftFiles", testFiltersOnSwiftFiles),
        ("testPrintsNoMarkdownIfNoViolations", testPrintsNoMarkdownIfNoViolations),
        ("testViolations", testViolations),
        ("testMarkdownReporting", testMarkdownReporting),
        ("testQuotesPathArguments", testQuotesPathArguments),
    ]
}
