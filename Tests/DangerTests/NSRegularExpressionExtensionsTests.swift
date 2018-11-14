import XCTest
@testable import Danger

class NSRegularExpressionExtensionsTests: XCTestCase {
    
    static var allTests = [
        ("test_firstMatchingString_passingRegex", test_firstMatchingString_passingRegex),
        ("test_firstMatchingString_failingRegex", test_firstMatchingString_failingRegex),
        ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests)
    ]
    
    let string = "Dogs and cats were wearing hats"
    
    func test_firstMatchingString_passingRegex() {
        let pattern = "(cats|hats)$"
        let expectedMatch = "hats"
        
        guard
            let expression = try? NSRegularExpression(pattern: pattern),
            let testMatch = expression.firstMatchingString(in: string)
        else {
            XCTFail(); return
        }
        
        XCTAssertEqual(testMatch, expectedMatch)
    }
    
    func test_firstMatchingString_failingRegex() {
        let pattern = "^(cats|hats)"
        
        guard let expression = try? NSRegularExpression(pattern: pattern) else {
                XCTFail(); return
        }
        
        let testMatch = expression.firstMatchingString(in: string)
        
        XCTAssertNil(testMatch)
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
