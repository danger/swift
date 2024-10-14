@testable import Danger
import DangerFixtures
import XCTest

// swiftlint:disable type_body_length file_length

final class DangerSwiftLintTests: XCTestCase {
    var executor: FakeShellExecutor!
    var fakePathProvider: FakeCurrentPathProvider!
    var danger: DangerDSL!
    var markdownMessage: String?

    override func setUp() {
        super.setUp()
        executor = FakeShellExecutor()
        fakePathProvider = FakeCurrentPathProvider()
        fakePathProvider.currentPath = "/Users/ash/bin"
        danger = githubFixtureDSL
    }

    override func tearDown() {
        executor = nil
        fakePathProvider = nil
        danger = nil
        markdownMessage = nil

        super.tearDown()
    }

    func testExecutesTheShell() {
        _ = SwiftLint.lint(danger: danger,
                           shellExecutor: executor,
                           swiftlintPath: "swiftlint",
                           currentPathProvider: fakePathProvider,
                           outputFilePath: "swiftlintReport.json",
                           readFile: mockedEmptyJSON)
        XCTAssertEqual(executor.invocations.count, 1)
        XCTAssertEqual(executor.invocations.first?.command, "swiftlint")
    }

    func testExecutesTheShellWithCustomSwiftLintPath() {
        _ = SwiftLint.lint(danger: danger,
                           shellExecutor: executor,
                           swiftlintPath: "Pods/SwiftLint/swiftlint",
                           currentPathProvider: fakePathProvider,
                           outputFilePath: "swiftlintReport.json",
                           readFile: mockedEmptyJSON)
        XCTAssertEqual(executor.invocations.count, 1)
        XCTAssertEqual(executor.invocations.first?.command, "Pods/SwiftLint/swiftlint")
    }

    func testDoNotExecuteSwiftlintWhenNoFilesToCheck() {
        let modified = [
            "CHANGELOG.md",
            "Harvey/SomeOtherFile.m",
            "circle.yml",
        ]

        danger = githubWithFilesDSL(created: [], modified: modified, deleted: [], fileMap: [:])

        _ = SwiftLint.lint(danger: danger,
                           shellExecutor: executor,
                           swiftlintPath: "swiftlint",
                           readFile: mockedEmptyJSON)
        XCTAssertEqual(executor.invocations.count, 0, "If there are no files to lint, Swiftlint should not be executed")
    }

    func testExecuteSwiftLintInInlineMode() {
        var warns = [(String, String, Int)]()
        let warnAction: (String, String, Int) -> Void = { warns.append(($0, $1, $2)) }
        var fails = [(String, String, Int)]()
        let failAction: (String, String, Int) -> Void = { fails.append(($0, $1, $2)) }

        _ = SwiftLint.lint(danger: danger,
                           shellExecutor: executor,
                           swiftlintPath: "swiftlint",
                           inline: true,
                           currentPathProvider: fakePathProvider,
                           outputFilePath: "swiftlintReport.json",
                           failInlineAction: failAction,
                           warnInlineAction: warnAction,
                           readFile: mockedViolationJSON)

        XCTAssertEqual(warns.first?.0,
                       "Opening braces should be preceded by a single space and on the same line as the declaration. (`opening_brace`)")
        XCTAssertEqual(warns.first?.1, "SomeFile.swift")
        XCTAssertEqual(warns.first?.2, 8)

        XCTAssertEqual(fails.first?.0, "Line should be 120 characters or less: currently 211 characters (`line_length`)")
        XCTAssertEqual(fails.first?.1, "AnotherFile.swift")
        XCTAssertEqual(fails.first?.2, 10)
    }

    func testExecuteSwiftWithStructAndInlineMode() {
        var warns = [(String, String, Int)]()
        let warnAction: (String, String, Int) -> Void = { warns.append(($0, $1, $2)) }
        var fails = [(String, String, Int)]()
        let failAction: (String, String, Int) -> Void = { fails.append(($0, $1, $2)) }

        _ = SwiftLint.lint(danger: danger,
                           shellExecutor: executor,
                           swiftlintPath: "swiftlint",
                           inline: true,
                           strict: true,
                           currentPathProvider: fakePathProvider,
                           outputFilePath: "swiftlintReport.json",
                           failInlineAction: failAction,
                           warnInlineAction: warnAction,
                           readFile: mockedViolationJSON)

        XCTAssertTrue(warns.isEmpty)
        XCTAssertEqual(fails.count, 2)

        XCTAssertEqual(fails[0].0,
                       "Opening braces should be preceded by a single space and on the same line as the declaration. (`opening_brace`)")
        XCTAssertEqual(fails[0].1, "SomeFile.swift")
        XCTAssertEqual(fails[0].2, 8)

        XCTAssertEqual(fails[1].0, "Line should be 120 characters or less: currently 211 characters (`line_length`)")
        XCTAssertEqual(fails[1].1, "AnotherFile.swift")
        XCTAssertEqual(fails[1].2, 10)
    }

    func testExecutesSwiftLintWithConfigWhenPassed() {
        let configFile = "/Path/to/config/.swiftlint.yml"

        _ = SwiftLint.lint(danger: danger,
                           shellExecutor: executor,
                           swiftlintPath: "swiftlint",
                           configFile: configFile,
                           currentPathProvider: fakePathProvider,
                           outputFilePath: "swiftlintReport.json",
                           readFile: mockedEmptyJSON)

        let swiftlintCommands = executor.invocations.filter { $0.command == "swiftlint" }
        XCTAssertTrue(!swiftlintCommands.isEmpty)
        for (_, arguments, _, _) in swiftlintCommands {
            XCTAssertTrue(arguments.contains("--config \"\(configFile)\""))
        }
    }

    func testExecutesVerboseIfNotQuiet() {
        _ = SwiftLint.lint(danger: danger,
                           shellExecutor: executor,
                           swiftlintPath: "swiftlint",
                           quiet: false,
                           currentPathProvider: fakePathProvider,
                           outputFilePath: "swiftlintReport.json",
                           readFile: mockedEmptyJSON)

        let swiftlintCommands = executor.invocations.filter { $0.command == "swiftlint" }
        XCTAssertTrue(!swiftlintCommands.isEmpty)
        for (_, arguments, _, _) in swiftlintCommands {
            XCTAssertFalse(arguments.contains("--quiet"))
        }
    }

    func testExecutesQuiet() {
        _ = SwiftLint.lint(danger: danger,
                           shellExecutor: executor,
                           swiftlintPath: "swiftlint",
                           quiet: true,
                           currentPathProvider: fakePathProvider,
                           outputFilePath: "swiftlintReport.json",
                           readFile: mockedEmptyJSON)

        let swiftlintCommands = executor.invocations.filter { $0.command == "swiftlint" }
        XCTAssertTrue(!swiftlintCommands.isEmpty)
        for (_, arguments, _, _) in swiftlintCommands {
            XCTAssertTrue(arguments.contains("--quiet"))
        }
    }

    func testSendsOuputFileToTheExecutorWhenLintingModifiedFiles() {
        let configFile = "/Path/to/config/.swiftlint.yml"

        _ = SwiftLint.lint(danger: danger,
                           shellExecutor: executor,
                           swiftlintPath: "swiftlint",
                           configFile: configFile,
                           currentPathProvider: fakePathProvider,
                           outputFilePath: "swiftlintReport.json",
                           readFile: mockedEmptyJSON)

        XCTAssertEqual(executor.invocations.first?.outputFile, "swiftlintReport.json")
    }

    func testSendsOuputFileToTheExecutorWhenLintingAllTheFiles() {
        let configFile = "/Path/to/config/.swiftlint.yml"

        _ = SwiftLint.lint(lintStyle: .all(directory: nil),
                           danger: danger,
                           shellExecutor: executor,
                           swiftlintPath: "swiftlint",
                           configFile: configFile,
                           currentPathProvider: fakePathProvider,
                           outputFilePath: "swiftlintReport.json",
                           readFile: mockedEmptyJSON)

        XCTAssertEqual(executor.invocations.first?.outputFile, "swiftlintReport.json")
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

        _ = SwiftLint.lint(lintStyle: .modifiedAndCreatedFiles(directory: directory),
                           danger: danger,
                           shellExecutor: executor,
                           swiftlintPath: "swiftlint",
                           currentPathProvider: fakePathProvider,
                           outputFilePath: "swiftlintReport.json",
                           readFile: mockedEmptyJSON)

        let swiftlintCommands = executor.invocations.filter { $0.command == "swiftlint" }
        XCTAssertEqual(swiftlintCommands.count, 1)
        XCTAssertEqual(swiftlintCommands.first!.environmentVariables,
                       ["SCRIPT_INPUT_FILE_COUNT": "1", "SCRIPT_INPUT_FILE_0": "Tests/SomeFile.swift"])
    }

    func testExecutesSwiftLintWhenLintingAllFiles() {
        let modified = [
            "Tests/SomeFile.swift",
            "Harvey/SomeOtherFile.swift",
            "Test Dir/SomeThirdFile.swift",
            "circle.yml",
        ]
        danger = githubWithFilesDSL(created: [], modified: modified, deleted: [], fileMap: [:])

        _ = SwiftLint.lint(lintStyle: .all(directory: nil),
                           danger: danger,
                           shellExecutor: executor,
                           swiftlintPath: "swiftlint",
                           currentPathProvider: fakePathProvider,
                           outputFilePath: "swiftlintReport.json",
                           readFile: mockedEmptyJSON)

        let swiftlintCommands = executor.invocations.filter { $0.command == "swiftlint" }
        XCTAssertEqual(swiftlintCommands.count, 1)
        XCTAssertEqual(swiftlintCommands.first!.environmentVariables.count, 0)
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

        _ = SwiftLint.lint(lintStyle: .all(directory: directory),
                           danger: danger,
                           shellExecutor: executor,
                           swiftlintPath: "swiftlint",
                           currentPathProvider: fakePathProvider,
                           outputFilePath: "swiftlintReport.json",
                           readFile: mockedEmptyJSON)

        let swiftlintCommand = executor.invocations.filter { $0.command == "swiftlint" }.first
        XCTAssertNotNil(swiftlintCommand)
        XCTAssertEqual(swiftlintCommand!.environmentVariables.count, 0)
        XCTAssertFalse(swiftlintCommand!.environmentVariables.values.contains { $0.contains("Tests/SomeFile.swift") })
        XCTAssertEqual(swiftlintCommand!.arguments.last, directory)
    }

    func testFiltersOnSwiftFiles() {
        _ = SwiftLint.lint(danger: danger,
                           shellExecutor: executor,
                           swiftlintPath: "swiftlint",
                           currentPathProvider: fakePathProvider,
                           outputFilePath: "swiftlintReport.json",
                           readFile: mockedEmptyJSON)

        let quoteCharacterSet = CharacterSet(charactersIn: "\"")
        let filesExtensions = Set(
            executor.invocations.first!.environmentVariables.filter {
                $0.key != "SCRIPT_INPUT_FILE_COUNT"
            }.values.compactMap {
                $0.split(separator: ".").last?.trimmingCharacters(in: quoteCharacterSet)
            }
        )
        XCTAssertEqual(filesExtensions, ["swift"])
    }

    func testSpecificFilesLintStyle() {
        let modified = [
            "Tests/SomeFile.swift",
            "Harvey/SomeOtherFile.swift",
            "ExampleTests.swift",
            "circle.yml",
        ]
        danger = githubWithFilesDSL(created: [], modified: modified, deleted: [], fileMap: [:])

        _ = SwiftLint.lint(lintStyle: .files(["Harvey/SomeOtherFile.swift"]),
                           danger: danger,
                           shellExecutor: executor,
                           swiftlintPath: "swiftlint",
                           currentPathProvider: fakePathProvider,
                           outputFilePath: "swiftlintReport.json",
                           readFile: mockedEmptyJSON)

        let swiftlintCommands = executor.invocations.filter { $0.command == "swiftlint" }
        XCTAssertEqual(swiftlintCommands.count, 1)
        XCTAssertEqual(swiftlintCommands.first!.environmentVariables,
                       ["SCRIPT_INPUT_FILE_COUNT": "1", "SCRIPT_INPUT_FILE_0": "Harvey/SomeOtherFile.swift"])
    }

    func testSpecificFilesSwiftOnlyFilter() {
        let modified = [
            "Tests/SomeFile.swift",
            "Harvey/SomeOtherFile.swift",
            "ExampleTests.swift",
            "circle.yml",
        ]
        danger = githubWithFilesDSL(created: [], modified: modified, deleted: [], fileMap: [:])

        _ = SwiftLint.lint(lintStyle: .files(["Harvey/SomeOtherFile.swift", "circle.yml"]),
                           danger: danger,
                           shellExecutor: executor,
                           swiftlintPath: "swiftlint",
                           currentPathProvider: fakePathProvider,
                           outputFilePath: "swiftlintReport.json",
                           readFile: mockedEmptyJSON)

        let swiftlintCommands = executor.invocations.filter { $0.command == "swiftlint" }
        XCTAssertEqual(swiftlintCommands.count, 1)
        XCTAssertEqual(swiftlintCommands.first!.environmentVariables,
                       ["SCRIPT_INPUT_FILE_COUNT": "1", "SCRIPT_INPUT_FILE_0": "Harvey/SomeOtherFile.swift"])
    }

    func testPrintsNoMarkdownIfNoViolations() {
        _ = SwiftLint.lint(danger: danger,
                           shellExecutor: executor,
                           swiftlintPath: "swiftlint",
                           currentPathProvider: fakePathProvider,
                           outputFilePath: "swiftlintReport.json",
                           readFile: mockedEmptyJSON)
        XCTAssertNil(markdownMessage)
    }

    func testViolations() {
        let modified = [
            "Tests/SomeFile.swift",
            "Harvey/SomeOtherFile.swift",
            "circle.yml",
        ]
        danger = githubWithFilesDSL(created: [], modified: modified, deleted: [], fileMap: [:])

        let violations = SwiftLint.lint(danger: danger,
                                        shellExecutor: executor,
                                        swiftlintPath: "swiftlint",
                                        currentPathProvider: fakePathProvider,
                                        markdownAction: writeMarkdown,
                                        readFile: mockedViolationJSON)
        XCTAssertEqual(violations.count, 2)
    }

    func testMarkdownReporting() {
        _ = SwiftLint.lint(danger: danger,
                           shellExecutor: executor,
                           swiftlintPath: "swiftlint",
                           currentPathProvider: fakePathProvider,
                           markdownAction: writeMarkdown,
                           readFile: mockedViolationJSON)
        XCTAssertNotNil(markdownMessage)
        XCTAssertEqual(markdownMessage?.contains("SwiftLint found issues"), true)
        XCTAssertEqual(
            markdownMessage?.contains(
                "Opening braces should be preceded by a single space and on the same line as the declaration. (`opening_brace`)"
            ), true
        )
    }

    func testMarkdownReportingInStrictMode() {
        _ = SwiftLint.lint(danger: danger,
                           shellExecutor: executor,
                           swiftlintPath: "swiftlint",
                           strict: true,
                           currentPathProvider: fakePathProvider,
                           markdownAction: writeMarkdown,
                           readFile: mockedViolationJSON)
        XCTAssertNotNil(markdownMessage)

        let lines = markdownMessage?.split(separator: "\n")
        XCTAssertEqual(lines?[3],
                       "Error | SomeFile.swift:8 | " +
                           "Opening braces should be preceded by a single space and on the same line as the declaration." +
                           " (`opening_brace`) |")
        XCTAssertEqual(lines?[4],
                       "Error | AnotherFile.swift:10 | Line should be 120 characters or less: currently 211 characters (`line_length`) |")
    }

    func testMarkdownReportingWithoutFilePath() {
        _ = SwiftLint.lint(danger: danger,
                           shellExecutor: executor,
                           swiftlintPath: "swiftlint",
                           strict: true,
                           currentPathProvider: fakePathProvider,
                           markdownAction: writeMarkdown,
                           readFile: mockedViolationJSONWitNoFile)
        XCTAssertNotNil(markdownMessage)

        let lines = markdownMessage?.split(separator: "\n")
        XCTAssertEqual(lines?[3],
                       "Error |  | " +
                           "Opening braces should be preceded by a single space and on the same line as the declaration. (`opening_brace`) |")
    }

    func testQuotesPathArguments() {
        let modified = [
            "Tests/SomeFile.swift",
            "Harvey/SomeOtherFile.swift",
            "Test Dir/SomeThirdFile.swift",
            "circle.yml",
        ]
        danger = githubWithFilesDSL(created: [], modified: modified, deleted: [], fileMap: [:])

        _ = SwiftLint.lint(danger: danger,
                           shellExecutor: executor,
                           swiftlintPath: "swiftlint",
                           currentPathProvider: fakePathProvider,
                           readFile: mockedEmptyJSON)

        let swiftlintCommands = executor.invocations.filter { $0.command == "swiftlint" }

        XCTAssertEqual(swiftlintCommands.count, 1)
        XCTAssertEqual(swiftlintCommands.first!.environmentVariables["SCRIPT_INPUT_FILE_2"], "Test Dir/SomeThirdFile.swift")
    }

    func testDeletesReportFile() {
        let reportDeleter = SpySwiftlintReportDeleter()

        _ = SwiftLint.lint(danger: danger,
                           shellExecutor: executor,
                           swiftlintPath: "swiftlint",
                           currentPathProvider: fakePathProvider,
                           outputFilePath: "swiftlintReport.json",
                           reportDeleter: reportDeleter,
                           readFile: mockedEmptyJSON)

        XCTAssertEqual(reportDeleter.receivedPath, "swiftlintReport.json")
    }

    func testSwiftlintCommandWhenPathIsBin() {
        let reportDeleter = SpySwiftlintReportDeleter()

        _ = SwiftLint.lint(danger: danger,
                           shellExecutor: executor,
                           swiftlintPath: .bin("swiftlint"),
                           currentPathProvider: fakePathProvider,
                           outputFilePath: "swiftlintReport.json",
                           reportDeleter: reportDeleter,
                           readFile: mockedEmptyJSON)

        XCTAssertEqual(executor.invocations.map(\.command), ["swiftlint"])
    }

    func testSwiftlintCommandWhenPathIsSwiftPackage() {
        let reportDeleter = SpySwiftlintReportDeleter()

        _ = SwiftLint.lint(danger: danger,
                           shellExecutor: executor,
                           swiftlintPath: .swiftPackage("Danger/Something"),
                           currentPathProvider: fakePathProvider,
                           outputFilePath: "swiftlintReport.json",
                           reportDeleter: reportDeleter,
                           readFile: mockedEmptyJSON)

        XCTAssertEqual(executor.invocations.map(\.command), ["swift run --package-path Danger/Something swiftlint"])
    }
}

extension DangerSwiftLintTests {
    func mockedViolationJSON(_: String) -> String {
        """
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

    func mockedViolationJSONWitNoFile(_: String) -> String {
        """
        [
            {
                "rule_id" : "opening_brace",
                "reason" : "Opening braces should be preceded by a single space and on the same line as the declaration.",
                "character" : 39,
                "severity" : "Warning",
                "file" : "",
                "type" : "Opening Brace Spacing",
                "line" : 0
            }
        ]
        """
    }

    func mockedEmptyJSON(_: String) -> String {
        "[]"
    }

    func writeMarkdown(_ message: String) {
        markdownMessage = message
    }
}

private final class SpySwiftlintReportDeleter: SwiftlintReportDeleting {
    private(set) var receivedPath: String?

    func deleteReport(atPath path: String) throws {
        receivedPath = path
    }
}

extension SwiftLint.SwiftlintPath: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self = .bin(value)
    }
}
