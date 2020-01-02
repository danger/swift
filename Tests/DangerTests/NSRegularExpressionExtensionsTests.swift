@testable import Danger
import XCTest

final class NSRegularExpressionExtensionsTests: XCTestCase {
    var string: String {
        "Dogs and cats were wearing hats"
    }

    func test_firstMatchingString_passingRegex() {
        let pattern = "(cats|hats)$"
        let expectedMatch = "hats"

        guard
            let expression = try? NSRegularExpression(pattern: pattern),
            let testMatch = expression.firstMatchingString(in: string)
        else {
            XCTFail(); return
        }

        XCTAssertEqual(testMatch, expectedMatch)
    }

    func test_firstMatchingString_failingRegex() {
        let pattern = "^(cats|hats)"

        guard let expression = try? NSRegularExpression(pattern: pattern) else {
            XCTFail(); return
        }

        let testMatch = expression.firstMatchingString(in: string)

        XCTAssertNil(testMatch)
    }
}
