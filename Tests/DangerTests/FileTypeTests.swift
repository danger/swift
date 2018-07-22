import XCTest
@testable import Danger

import XCTest

class FileTypeTests: XCTestCase {
    
    static var allTests = [
        ("test_extension_matchesRawValue", test_extension_matchesRawValue),
    ]

    func test_extension_matchesRawValue() {
        FileType.allCases.forEach { type in
            XCTAssertEqual(type.extension, type.rawValue)
        }
    }
    
}
