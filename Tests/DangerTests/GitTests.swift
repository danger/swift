import XCTest
import Danger

class GitTests: XCTestCase {
    static var allTests = [
        ("testExample", testExample),
    ]
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}

extension Git: AutoEquatable {}
extension GitCommit: AutoEquatable {}
extension GitCommitAuthor: AutoEquatable {}
