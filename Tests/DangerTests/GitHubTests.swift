import XCTest
@testable import Danger

class GitHubTests: XCTestCase {
    static var allTests = [
        ("test_GitHubUser_decode", test_GitHubUser_decode),
    ]
    
    func test_GitHubUser_decode() throws {
        guard let data = GitHubUserJSON.data(using: .utf8) else {
            XCTFail("Cannot generate Data")
            return
        }
        
        let user: GitHubUser = try JSONDecoder().decode(GitHubUser.self, from: data)
        
        XCTAssertEqual("yhkaplan", user.login)
        XCTAssertEqual(25879490, user.id)
        XCTAssertEqual(GitHubUser.UserType.user, user.userType)
    }
}
