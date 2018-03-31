import XCTest
@testable import Danger

class DateFormatterExtensionTests: XCTestCase {
    static var allTests = [
        ("test_DateFormatter_dateFromString", test_DateFormatter_dateFromString),
        ("test_DateFormatter_nilFromInvalidString", test_DateFormatter_nilFromInvalidString)
    ]
    
    private let dateFormatter = DateFormatter.defaultDateFormatter
    
    func test_DateFormatter_dateFromString() {
        var dateComponents = DateComponents()
        dateComponents.year = 2020
        dateComponents.month = 6
        dateComponents.day = 24
        
        dateComponents.hour = 23
        dateComponents.minute = 13
        dateComponents.second = 8
        dateComponents.timeZone = TimeZone(abbreviation: "GMT")
        dateComponents.calendar = Calendar(identifier: .gregorian)
        
        guard let testDate = dateFormatter.date(from: "2020-06-24T23:13:08Z"),
        let correctDate = dateComponents.date else {
            XCTFail("Could not generate date")
            return
        }

        XCTAssertEqual(testDate, correctDate)
    }
    
    func test_DateFormatter_nilFromInvalidString() {
        XCTAssertNil(dateFormatter.date(from: "2020-0d-24T23:13:08Z"))
    }
}
