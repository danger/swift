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
}

extension ImportsFinderTests {
    private var stringWithImports: String {
        return """
        // fileImport: File1

        text text

        // fileImport: File2
        """
    }

    private var stringWithoutImports: String {
        return """
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
