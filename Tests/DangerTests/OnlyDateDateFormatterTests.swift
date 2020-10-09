@testable import Danger
import Foundation
import XCTest

final class OnlyDateDateFormatterTests: XCTestCase {
    var formatter: DateFormatter {
        DateFormatter.onlyDateDateFormatter
    }

    func testParsesDate() {
        let testDateString = "2019-04-10"

        XCTAssertEqual(formatter.date(from: testDateString), Date(timeIntervalSince1970: 1_554_854_400.0))
    }
}
