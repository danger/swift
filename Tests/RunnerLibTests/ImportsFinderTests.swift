import RunnerLib
import XCTest

final class ImportsFinderTests: XCTestCase {
    var importsFinder: ImportsFinder!

    override func setUp() {
        super.setUp()
        importsFinder = ImportsFinder()
    }

    override func tearDown() {
        importsFinder = nil
        super.tearDown()
    }

    func testItRetunsTheCorrectFilePathsWhenThePassedStringContainsImports() {
        checkReturnsTheCorrectFilePaths(string: stringWithImports, expectedResult: ["File1", "File2"])
    }

    func testItRetunsAnEmptyListWhenThePassedStringDoesntContainImports() {
        checkReturnsTheCorrectFilePaths(string: stringWithoutImports, expectedResult: [])
    }

    func testResolveImportPath() {
        let dangerfilePath = "/path/to/danger/swift/Dangerfile.swift"
        XCTAssertEqual(importsFinder.resolveImportPath("DangerfileExtensions/ChangelogCheck.swift", relativeTo: dangerfilePath), "/path/to/danger/swift/DangerfileExtensions/ChangelogCheck.swift")

        XCTAssertEqual(importsFinder.resolveImportPath("SomeFile", relativeTo: dangerfilePath), "/path/to/danger/swift/SomeFile")
    }
}

extension ImportsFinderTests {
    private var stringWithImports: String {
        """
        // fileImport: File1

        text text

        // fileImport: File2
        """
    }

    private var stringWithoutImports: String {
        """
        // comment

        text text

        more text
        """
    }

    private func checkReturnsTheCorrectFilePaths(string: String, expectedResult: [String]) {
        let files = importsFinder.findImports(inString: string)
        XCTAssertEqual(files, expectedResult)
    }
}
