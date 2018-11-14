import XCTest
@testable import Danger

import XCTest

final class FileTypeTests: XCTestCase {
    
    static var allTests = [
        ("test_extension_matchesRawValue", test_extension_matchesRawValue),
        ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests)
    ]

    func test_extension_matchesRawValue() {
        FileType.allCases.forEach { type in
            XCTAssertEqual(type.extension, type.rawValue)
        }
    }
    
    func testLinuxTestSuiteIncludesAllTests() {
        #if !os(Linux)
        let thisClass = type(of: self)
        let linuxCount = thisClass.allTests.count
        let darwinCount = thisClass.defaultTestSuite.tests.count
        XCTAssertEqual(linuxCount, darwinCount, "\(darwinCount - linuxCount) tests are missing from allTests")
        #endif
    }
}
