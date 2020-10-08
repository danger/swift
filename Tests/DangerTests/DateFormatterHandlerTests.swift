@testable import Danger
import Foundation
import XCTest

final class DateFormatterHandlerTests: XCTestCase {
    func testRegularParseSuccess() throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom(DateFormatter.dateFormatterHandler)

        let json = """
            { "date": "2019-04-10T21:57:45.000Z" }
        """
        let data = Data(json.utf8)

        let dummy = try decoder.decode(DummyModel.self, from: data)
        XCTAssertEqual(dummy.date, Date(timeIntervalSince1970: 1_554_933_465.000))
    }

    func testOnlyDateParseSuccess() throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom(DateFormatter.dateFormatterHandler)

        let json = """
            { "date": "2019-04-10" }
        """
        let data = Data(json.utf8)

        let dummy = try decoder.decode(DummyModel.self, from: data)
        XCTAssertEqual(dummy.date, Date(timeIntervalSince1970: 1_554_854_400.000))
    }

    func testUnexpectedDateThrows() {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom(DateFormatter.dateFormatterHandler)

        let json = """
            { "date": "2019*04*10" }
        """
        let data = Data(json.utf8)

        XCTAssertThrowsError(try decoder.decode(DummyModel.self, from: data)) { error in
            XCTAssertEqual(error.localizedDescription, "Format Invalid with path \"date\", date string: \"2019*04*10\"")
        }
    }

    // MARK: Test Helpers

    private struct DummyModel: Decodable {
        let date: Date
    }
}
