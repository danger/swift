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

extension DangerJSVersionFinderTests {
    static let __allTests = [
        ("testItSendsTheCorrectCommandAndReturnsTheCorrectResult", testItSendsTheCorrectCommandAndReturnsTheCorrectResult),
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

extension SPMDangerTests {
    static let __allTests = [
        ("testItBuildsTheDependenciesIfTheDepsLibIsNotPresent", testItBuildsTheDependenciesIfTheDepsLibIsNotPresent),
        ("testItDoesntBuildTheDependenciesIfTheDepsLibIsPresent", testItDoesntBuildTheDependenciesIfTheDepsLibIsPresent),
        ("testItReturnsFalseWhenThePackageHasNotTheDangerLib", testItReturnsFalseWhenThePackageHasNotTheDangerLib),
        ("testItReturnsFalseWhenThereIsNoPackage", testItReturnsFalseWhenThereIsNoPackage),
        ("testItReturnsTheCorrectDepsImport", testItReturnsTheCorrectDepsImport),
        ("testItReturnsTrueWhenThePackageHasTheDangerLib", testItReturnsTrueWhenThePackageHasTheDangerLib),
    ]
}

#if !os(macOS)
    public func __allTests() -> [XCTestCaseEntry] {
        return [
            testCase(CliParserTests.__allTests),
            testCase(DangerCommandTests.__allTests),
            testCase(DangerFileGeneratorTests.__allTests),
            testCase(DangerJSVersionFinderTests.__allTests),
            testCase(HelpMessagePresenterTests.__allTests),
            testCase(ImportsFinderTests.__allTests),
            testCase(SPMDangerTests.__allTests),
        ]
    }
#endif
