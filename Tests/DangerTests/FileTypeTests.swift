@testable import Danger
import XCTest

final class FileTypeTests: XCTestCase {
    func test_extension_matchesRawValue() {
        for type in FileType.allCases {
            XCTAssertEqual(type.extension, type.rawValue)
        }
    }
}
