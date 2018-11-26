import XCTest

extension CliParserTests {
    static let __allTests = [
        ("testItReturnsNilIfTheJSONDoesntContainCliArgs", testItReturnsNilIfTheJSONDoesntContainCliArgs),
        ("testItReturnsTheCliArgsIfTheJSONIsCorrect", testItReturnsTheCliArgsIfTheJSONIsCorrect),
        ("testItReturnsTheCliArgsIfTheJSONIsCorrectButDoesntContainAllTheFields", testItReturnsTheCliArgsIfTheJSONIsCorrectButDoesntContainAllTheFields),
    ]
}

extension DangerCommandTests {
    static let __allTests = [
        ("testItReturnsTheCorrectCommandsListText", testItReturnsTheCorrectCommandsListText),
    ]
}

extension DangerFileGeneratorTests {
    static let __allTests = [
        ("testItGeneratesTheCorrectFileWhenOneOfTheImportedFilesIsMissing", testItGeneratesTheCorrectFileWhenOneOfTheImportedFilesIsMissing),
        ("testItGeneratesTheCorrectFileWhenThereAreNoImports", testItGeneratesTheCorrectFileWhenThereAreNoImports),
        ("testItGeneratesTheCorrectFileWhenThereIsAreMultipleImports", testItGeneratesTheCorrectFileWhenThereIsAreMultipleImports),
        ("testItGeneratesTheCorrectFileWhenThereIsASingleImport", testItGeneratesTheCorrectFileWhenThereIsASingleImport),
    ]
}

extension HelpMessagePresenterTests {
    static let __allTests = [
        ("testIsShowsTheCommandListWhenThereIsNoCommand", testIsShowsTheCommandListWhenThereIsNoCommand),
    ]
}

extension ImportsFinderTests {
    static let __allTests = [
        ("testItRetunsAnEmptyListWhenThePassedStringDoesntContainImports", testItRetunsAnEmptyListWhenThePassedStringDoesntContainImports),
        ("testItRetunsTheCorrectFilePathsWhenThePassedStringContainsImports", testItRetunsTheCorrectFilePathsWhenThePassedStringContainsImports),
    ]
}

#if !os(macOS)
    public func __allTests() -> [XCTestCaseEntry] {
        return [
            testCase(CliParserTests.__allTests),
            testCase(DangerCommandTests.__allTests),
            testCase(DangerFileGeneratorTests.__allTests),
            testCase(HelpMessagePresenterTests.__allTests),
            testCase(ImportsFinderTests.__allTests),
        ]
    }
#endif
