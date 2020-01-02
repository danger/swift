@testable import Danger
import DangerFixtures
import XCTest

final class DangerUtilsLineSearchTests: XCTestCase {
    var fileContent: String {
        """
        not here
        no
        match
        not here
        no
        match
        """.replacingOccurrences(of: "\n", with: "\\n")
    }

    func testItReturnsAnEmptyArrayIfNoResultsAreFound() throws {
        let danger = githubWithFilesDSL(created: ["file.swift"], fileMap: ["file.swift": fileContent])

        XCTAssertTrue(danger.utils.lines(for: "No results", inFile: "file.swift").isEmpty)
    }

    func testItReturnsTheCorrectResultsIfTheSearchedStringIsPresent() throws {
        let danger = githubWithFilesDSL(created: ["file.swift"], fileMap: ["file.swift": fileContent])

        XCTAssert(danger.utils.lines(for: "match", inFile: "file.swift") == [3, 6])
    }
}
