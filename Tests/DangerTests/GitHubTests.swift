import XCTest
import Danger

class GitHubTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
    }
    
}
#if os(Linux)
extension GitHubTests {
	static var allTests : [(String, GitHubTests -> () throws -> Void)] {
		return [
			("testExample", testExample),
		]
	}
}
#endif 

