@testable import Danger
import XCTest

final class ViolationTests: XCTestCase {
    func testDecoding() throws {
        let json = """
        {
            "rule_id" : "opening_brace",
            "reason" : "Opening braces should be preceded by a single space and on the same line as the declaration.",
            "character" : 39,
            "file" : "/Users/ash/bin/Harvey/Sources/Harvey/Harvey.swift",
            "severity" : "Warning",
            "type" : "Opening Brace Spacing",
            "line" : 8
        }
        """
        let subject = try JSONDecoder().decode(SwiftLintViolation.self, from: Data(json.utf8))
        XCTAssertEqual(subject.ruleID, "opening_brace")
        XCTAssertEqual(subject.reason, "Opening braces should be preceded by a single space and on the same line as the declaration.")
        XCTAssertEqual(subject.line, 8)
        XCTAssertEqual(subject.file, "/Users/ash/bin/Harvey/Sources/Harvey/Harvey.swift")
        XCTAssertEqual(subject.severity, .warning)
    }

    static var allTests = [
        ("testDecoding", testDecoding)
    ]
}
