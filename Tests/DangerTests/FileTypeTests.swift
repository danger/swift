@testable import Danger
import XCTest

final class FileTypeTests: XCTestCase {
    func test_extension_matchesRawValue() {
        FileType.allCases.forEach { type in
            XCTAssertEqual(type.extension, type.rawValue)
        }
    }
}
