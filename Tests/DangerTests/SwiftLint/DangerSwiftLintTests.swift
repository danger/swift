@testable import Danger
import DangerFixtures
import ShellRunnerTestUtils
import XCTest

// swiftlint:disable type_body_length file_length

final class DangerSwiftLintTests: XCTestCase {
    var shell: ShellRunnerMock!
    var fakePathProvider: FakeCurrentPathProvider!
    var danger: DangerDSL!
    var markdownMessage: String?

    override func setUp() {
        super.setUp()
        shell = ShellRunnerMock()
        fakePathProvider = FakeCurrentPathProvider()
        fakePathProvider.currentPath = "/Users/ash/bin"
        danger = githubFixtureDSL
    }

    override func tearDown() {
        shell = nil
        fakePathProvider = nil
        danger = nil
        markdownMessage = nil

        super.tearDown()
    }

    func testExecutesTheShell() {
        _ = SwiftLint.lint(danger: danger,
                           shell: shell,
                           swiftlintPath: "swiftlint",
                           currentPathProvider: fakePathProvider,
                           outputFilePath: "swiftlintReport.json",
                           readFile: mockedEmptyJSON)

        XCTAssertEqual(shell.calls.count, 1)
        XCTAssertEqual(
            shell.calls.first,
            .run(.init(
                "swiftlint",
                .expectedSwiftLintArguments,
                .expectedEnvironmentVariables,
                "swiftlintReport.json"
            ))
        )
    }

    func testExecutesTheShellWithCustomSwiftLintPath() {
        _ = SwiftLint.lint(danger: danger,
                           shell: shell,
                           swiftlintPath: "Pods/SwiftLint/swiftlint",
                           currentPathProvider: fakePathProvider,
                           outputFilePath: "swiftlintReport.json",
                           readFile: mockedEmptyJSON)
        XCTAssertEqual(shell.calls.count, 1)
        XCTAssertEqual(
            shell.calls.first,
            .run(.init(
                "Pods/SwiftLint/swiftlint",
                .expectedSwiftLintArguments,
                .expectedEnvironmentVariables,
                "swiftlintReport.json"
            ))
        )
    }

    func testDoNotExecuteSwiftlintWhenNoFilesToCheck() {
        let modified = [
            "CHANGELOG.md",
            "Harvey/SomeOtherFile.m",
            "circle.yml",
        ]

        danger = githubWithFilesDSL(created: [], modified: modified, deleted: [], fileMap: [:])

        _ = SwiftLint.lint(danger: danger,
                           shell: shell,
                           swiftlintPath: "swiftlint",
                           readFile: mockedEmptyJSON)
        XCTAssertEqual(shell.calls.count, 0, "If there are no files to lint, Swiftlint should not be executed")
    }

    func testExecuteSwiftLintInInlineMode() {
        var warns = [(String, String, Int)]()
        let warnAction: (String, String, Int) -> Void = { warns.append(($0, $1, $2)) }
        var fails = [(String, String, Int)]()
        let failAction: (String, String, Int) -> Void = { fails.append(($0, $1, $2)) }

        _ = SwiftLint.lint(danger: danger,
                           shell: shell,
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
                           shell: shell,
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

    func testExecutesSwiftLintWithConfigWhenPassed() throws {
        let configFile = "/Path/to/config/.swiftlint.yml"

        _ = SwiftLint.lint(danger: danger,
                           shell: shell,
                           swiftlintPath: "swiftlint",
                           configFile: configFile,
                           currentPathProvider: fakePathProvider,
                           outputFilePath: "swiftlintReport.json",
                           readFile: mockedEmptyJSON)

        let callParameters = try XCTUnwrap(shell.calls.first?.runCallParameters)
        XCTAssertEqual(shell.calls.count, 1)
        XCTAssertTrue(callParameters.arguments.contains("--config \"\(configFile)\""))
    }

    func testExecutesVerboseIfNotQuiet() throws {
        _ = SwiftLint.lint(danger: danger,
                           shell: shell,
                           swiftlintPath: "swiftlint",
                           quiet: false,
                           currentPathProvider: fakePathProvider,
                           outputFilePath: "swiftlintReport.json",
                           readFile: mockedEmptyJSON)

        let callParameters = try XCTUnwrap(shell.calls.first?.runCallParameters)
        XCTAssertEqual(shell.calls.count, 1)
        XCTAssertFalse(callParameters.arguments.contains("--quiet"))
    }

    func testExecutesQuiet() throws {
        _ = SwiftLint.lint(danger: danger,
                           shell: shell,
                           swiftlintPath: "swiftlint",
                           quiet: true,
                           currentPathProvider: fakePathProvider,
                           outputFilePath: "swiftlintReport.json",
                           readFile: mockedEmptyJSON)

        let callParameters = try XCTUnwrap(shell.calls.first?.runCallParameters)
        XCTAssertEqual(shell.calls.count, 1)
        XCTAssertTrue(callParameters.arguments.contains("--quiet"))
    }

    func testSendsOuputFileToTheShellWhenLintingModifiedFiles() {
        let configFile = "/Path/to/config/.swiftlint.yml"

        _ = SwiftLint.lint(danger: danger,
                           shell: shell,
                           swiftlintPath: "swiftlint",
                           configFile: configFile,
                           currentPathProvider: fakePathProvider,
                           outputFilePath: "swiftlintReport.json",
                           readFile: mockedEmptyJSON)

        XCTAssertEqual(shell.calls.count, 1)
        XCTAssertEqual(
            shell.calls.first,
            .run(.init(
                "swiftlint",
                ["lint", "--reporter json", "--quiet", "--config \"/Path/to/config/.swiftlint.yml\"", "--use-script-input-files", "--force-exclude"],
                .expectedEnvironmentVariables,
                "swiftlintReport.json"
            ))
        )
    }

    func testSendsOuputFileToTheShellWhenLintingAllTheFiles() {
        let configFile = "/Path/to/config/.swiftlint.yml"

        _ = SwiftLint.lint(lintStyle: .all(directory: nil),
                           danger: danger,
                           shell: shell,
                           swiftlintPath: "swiftlint",
                           configFile: configFile,
                           currentPathProvider: fakePathProvider,
                           outputFilePath: "swiftlintReport.json",
                           readFile: mockedEmptyJSON)

        XCTAssertEqual(shell.calls.count, 1)
        XCTAssertEqual(
            shell.calls.first,
            .run(.init(
                "swiftlint",
                ["lint", "--reporter json", "--quiet", "--config \"/Path/to/config/.swiftlint.yml\""],
                [:],
                "swiftlintReport.json"
            ))
        )
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
                           shell: shell,
                           swiftlintPath: "swiftlint",
                           currentPathProvider: fakePathProvider,
                           outputFilePath: "swiftlintReport.json",
                           readFile: mockedEmptyJSON)

        XCTAssertEqual(shell.calls.count, 1)
        XCTAssertEqual(
            shell.calls.first,
            .run(.init(
                "swiftlint",
                .expectedSwiftLintArguments,
                [
                    "SCRIPT_INPUT_FILE_COUNT": "1",
                    "SCRIPT_INPUT_FILE_0": "Tests/SomeFile.swift"
                ],
                "swiftlintReport.json"
            ))
        )
    }

    func testExecutesSwiftLintWhenLintingAllFiles() throws {
        let modified = [
            "Tests/SomeFile.swift",
            "Harvey/SomeOtherFile.swift",
            "Test Dir/SomeThirdFile.swift",
            "circle.yml",
        ]
        danger = githubWithFilesDSL(created: [], modified: modified, deleted: [], fileMap: [:])

        _ = SwiftLint.lint(lintStyle: .all(directory: nil),
                           danger: danger,
                           shell: shell,
                           swiftlintPath: "swiftlint",
                           currentPathProvider: fakePathProvider,
                           outputFilePath: "swiftlintReport.json",
                           readFile: mockedEmptyJSON)

        let call = try XCTUnwrap(shell.calls.first)
        XCTAssertEqual(shell.calls.count, 1)
        XCTAssertEqual(call, .run(.init("swiftlint", ["lint", "--reporter json", "--quiet"], [:], "swiftlintReport.json")))
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
                           shell: shell,
                           swiftlintPath: "swiftlint",
                           currentPathProvider: fakePathProvider,
                           outputFilePath: "swiftlintReport.json",
                           readFile: mockedEmptyJSON)

        XCTAssertEqual(shell.calls.count, 1)
        XCTAssertEqual(shell.calls.first, .run(.init("swiftlint", ["lint", "--reporter json", "--quiet", "--path \"Tests\""], [:], "swiftlintReport.json")))
    }

    func testFiltersOnSwiftFiles() throws {
        _ = SwiftLint.lint(danger: danger,
                           shell: shell,
                           swiftlintPath: "swiftlint",
                           currentPathProvider: fakePathProvider,
                           outputFilePath: "swiftlintReport.json",
                           readFile: mockedEmptyJSON)

        let parameters = try XCTUnwrap(shell.calls.first?.runCallParameters)
        let quoteCharacterSet = CharacterSet(charactersIn: "\"")
        let fileExtensions = Set(
            parameters
                .environmentVariables
                .filter { $0.key != "SCRIPT_INPUT_FILE_COUNT" }
                .values
                .compactMap { $0.split(separator: ".").last?.trimmingCharacters(in: quoteCharacterSet) }
        )
        XCTAssertEqual(fileExtensions, ["swift"])
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
                           shell: shell,
                           swiftlintPath: "swiftlint",
                           currentPathProvider: fakePathProvider,
                           outputFilePath: "swiftlintReport.json",
                           readFile: mockedEmptyJSON)

        XCTAssertEqual(shell.calls.count, 1)
        XCTAssertEqual(
            shell.calls.first,
            .run(.init(
                "swiftlint",
                .expectedSwiftLintArguments,
                [
                    "SCRIPT_INPUT_FILE_COUNT": "1",
                    "SCRIPT_INPUT_FILE_0": "Harvey/SomeOtherFile.swift"
                ],
                "swiftlintReport.json"
            ))
        )
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
                           shell: shell,
                           swiftlintPath: "swiftlint",
                           currentPathProvider: fakePathProvider,
                           outputFilePath: "swiftlintReport.json",
                           readFile: mockedEmptyJSON)

        XCTAssertEqual(shell.calls.count, 1)
        XCTAssertEqual(
            shell.calls.first,
            .run(.init(
                "swiftlint",
                .expectedSwiftLintArguments,
                [
                    "SCRIPT_INPUT_FILE_COUNT": "1",
                    "SCRIPT_INPUT_FILE_0": "Harvey/SomeOtherFile.swift"
                ],
                "swiftlintReport.json"
            ))
        )
    }

    func testPrintsNoMarkdownIfNoViolations() {
        _ = SwiftLint.lint(danger: danger,
                           shell: shell,
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
                                        shell: shell,
                                        swiftlintPath: "swiftlint",
                                        currentPathProvider: fakePathProvider,
                                        markdownAction: writeMarkdown,
                                        readFile: mockedViolationJSON)
        XCTAssertEqual(violations.count, 2)
    }

    func testMarkdownReporting() {
        _ = SwiftLint.lint(danger: danger,
                           shell: shell,
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
                           shell: shell,
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
                           shell: shell,
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

    func testQuotesPathArguments() throws {
        let modified = [
            "Tests/SomeFile.swift",
            "Harvey/SomeOtherFile.swift",
            "Test Dir/SomeThirdFile.swift",
            "circle.yml",
        ]
        danger = githubWithFilesDSL(created: [], modified: modified, deleted: [], fileMap: [:])

        _ = SwiftLint.lint(danger: danger,
                           shell: shell,
                           swiftlintPath: "swiftlint",
                           currentPathProvider: fakePathProvider,
                           readFile: mockedEmptyJSON)

        let parameters = try XCTUnwrap(shell.calls.first?.runCallParameters)
        XCTAssertEqual(shell.calls.count, 1)
        XCTAssertEqual(parameters.environmentVariables["SCRIPT_INPUT_FILE_2"], "Test Dir/SomeThirdFile.swift")
    }

    func testDeletesReportFile() {
        let reportDeleter = SpySwiftlintReportDeleter()

        _ = SwiftLint.lint(danger: danger,
                           shell: shell,
                           swiftlintPath: "swiftlint",
                           currentPathProvider: fakePathProvider,
                           outputFilePath: "swiftlintReport.json",
                           reportDeleter: reportDeleter,
                           readFile: mockedEmptyJSON)

        XCTAssertEqual(reportDeleter.receivedPath, "swiftlintReport.json")
    }

    func testSwiftlintCommandWhenPathIsBin() throws {
        let reportDeleter = SpySwiftlintReportDeleter()

        _ = SwiftLint.lint(danger: danger,
                           shell: shell,
                           swiftlintPath: .bin("swiftlint"),
                           currentPathProvider: fakePathProvider,
                           outputFilePath: "swiftlintReport.json",
                           reportDeleter: reportDeleter,
                           readFile: mockedEmptyJSON)

        let parameters = try XCTUnwrap(shell.calls.first?.runCallParameters)
        XCTAssertEqual(parameters.command, "swiftlint")
        XCTAssertEqual(shell.calls.count, 1)
    }

    func testSwiftlintCommandWhenPathIsSwiftPackage() throws {
        let reportDeleter = SpySwiftlintReportDeleter()

        _ = SwiftLint.lint(danger: danger,
                           shell: shell,
                           swiftlintPath: .swiftPackage("Danger/Something"),
                           currentPathProvider: fakePathProvider,
                           outputFilePath: "swiftlintReport.json",
                           reportDeleter: reportDeleter,
                           readFile: mockedEmptyJSON)

        let parameters = try XCTUnwrap(shell.calls.first?.runCallParameters)
        XCTAssertEqual(parameters.command, "swift run --package-path Danger/Something swiftlint")
        XCTAssertEqual(shell.calls.count, 1)
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

private extension Array where Element == String {
    static var expectedSwiftLintArguments: Self {
        ["lint", "--reporter json", "--quiet", "--use-script-input-files", "--force-exclude"]
    }
}

private extension Dictionary where Key == String, Value == String {
    static var expectedEnvironmentVariables: Self {
        [
            "SCRIPT_INPUT_FILE_5": "Kiosk/HelperFunctions.swift",
            "SCRIPT_INPUT_FILE_6": "KioskTests/Bid Fulfillment/ConfirmYourBidArtsyLoginViewControllerTests.swift",
            "SCRIPT_INPUT_FILE_13": "KioskTests/Models/SaleArtworkTests.swift",
            "SCRIPT_INPUT_FILE_4": "Kiosk/Auction Listings/ListingsViewModel.swift",
            "SCRIPT_INPUT_FILE_11": "KioskTests/Bid Fulfillment/SwipeCreditCardViewControllerTests.swift",
            "SCRIPT_INPUT_FILE_7": "KioskTests/Bid Fulfillment/ConfirmYourBidEnterYourEmailViewControllerTests.swift",
            "SCRIPT_INPUT_FILE_14": "KioskTests/XAppTokenSpec.swift",
            "SCRIPT_INPUT_FILE_12": "KioskTests/ListingsViewControllerTests.swift",
            "SCRIPT_INPUT_FILE_10": "KioskTests/Bid Fulfillment/RegistrationPasswordViewModelTests.swift",
            "SCRIPT_INPUT_FILE_9": "KioskTests/Bid Fulfillment/RegistrationEmailViewControllerTests.swift",
            "SCRIPT_INPUT_FILE_8": "KioskTests/Bid Fulfillment/LoadingViewControllerTests.swift",
            "SCRIPT_INPUT_FILE_3": "Kiosk/App/Networking/XAppToken.swift",
            "SCRIPT_INPUT_FILE_COUNT": "15",
            "SCRIPT_INPUT_FILE_0": "Kiosk/App/Logger.swift",
            "SCRIPT_INPUT_FILE_1": "Kiosk/App/Networking/NetworkLogger.swift",
            "SCRIPT_INPUT_FILE_2": "Kiosk/App/Networking/Networking.swift"
        ]
    }
}
