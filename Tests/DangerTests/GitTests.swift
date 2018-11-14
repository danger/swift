import XCTest
import Danger

final class GitTests: XCTestCase {
    static var allTests = [
        ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests)
    ]
    
    func testLinuxTestSuiteIncludesAllTests() {
        #if !os(Linux)
        let thisClass = type(of: self)
        let linuxCount = thisClass.allTests.count
        let darwinCount = thisClass.defaultTestSuite.tests.count
        XCTAssertEqual(linuxCount, darwinCount, "\(darwinCount - linuxCount) tests are missing from allTests")
        #endif
    }
}
