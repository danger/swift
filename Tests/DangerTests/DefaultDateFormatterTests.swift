@testable import Danger
import Foundation
import XCTest

final class DefaultDateFormatterTests: XCTestCase {
    var formatter: DateFormatter {
        DateFormatter.defaultDateFormatter
    }

    func testParsesDateWithMilliseconds() {
        let testDateString = "2019-04-10T21:56:43.500Z"

        XCTAssertEqual(formatter.date(from: testDateString), Date(timeIntervalSince1970: 1_554_933_403.5))
    }

    func testParsesDateWithoutMilliseconds() {
        let testDateString = "2019-04-10T21:56:43Z"

        XCTAssertEqual(formatter.date(from: testDateString), Date(timeIntervalSince1970: 1_554_933_403))
    }
}
