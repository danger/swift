import XCTest
@testable import Danger

class GitHubTests: XCTestCase {
    static var allTests = [
        ("test_GitHubUser_decode", test_GitHubUser_decode),
        ("test_GitHubMilestone_decodeWithSomeParameters", test_GitHubMilestone_decodeWithSomeParameters),
        ("test_GitHubMilestone_decodeWithAllParameters", test_GitHubMilestone_decodeWithAllParameters),
    ]
    
    func test_GitHubUser_decode() throws {
        guard let data = GitHubUserJSON.data(using: .utf8) else {
            XCTFail("Cannot generate data")
            return
        }
        
        let correctUser = GitHubUser(id: 25879490, login: "yhkaplan", userType: .user)
        let testUser: GitHubUser = try JSONDecoder().decode(GitHubUser.self, from: data)
        
        XCTAssertEqual(testUser, correctUser)
    }
    
    func test_GitHubMilestone_decodeWithSomeParameters() throws {
        let dateFormatter = DateFormatter.defaultDateFormatter
        
        guard let data = GitHubMilestoneJSONWithSomeParameters.data(using: .utf8),
        let createdAt = dateFormatter.date(from: "2018-01-20T16:29:28Z"),
            let updatedAt = dateFormatter.date(from: "2018-02-27T06:23:58Z") else {
            XCTFail("Cannot generate data")
            return
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        let milestone: GitHubMilestone = try decoder.decode(GitHubMilestone.self, from: data)
        let creator = GitHubUser(id: 739696, login: "rnystrom", userType: .user)
        
        // Make milestone conform to autoequatable to get rid of this rubbish
        XCTAssertNil(milestone.closedAt)
        XCTAssertEqual(milestone.closedIssues, 2)
        XCTAssertEqual(milestone.createdAt, createdAt)
        XCTAssertEqual(milestone.creator, creator)
        XCTAssertEqual(milestone.description, "kdsjfls")
        XCTAssertNil(milestone.dueOn)
        XCTAssertEqual(milestone.id, 3050458)
        XCTAssertEqual(milestone.number, 11)
        XCTAssertEqual(milestone.openIssues, 0)
        XCTAssertEqual(milestone.state, GitHubMilestone.MilestoneState.open)
        XCTAssertEqual(milestone.title, "1.19.0")
        XCTAssertEqual(milestone.updatedAt, updatedAt)
    }
    
    func test_GitHubMilestone_decodeWithAllParameters() throws {
        
    }
}

public protocol AutoEquatable {}

extension GitHubUser: AutoEquatable {}
extension GitHubMilestone: AutoEquatable {}
extension GitHub: AutoEquatable {}
extension GitHubPR: AutoEquatable {}
extension GitHubTeam: AutoEquatable {}
extension GitHubRequestedReviewers: AutoEquatable {}
extension GitHubMergeRef: AutoEquatable {}
extension GitHubRepo: AutoEquatable {}
extension GitHubReview: AutoEquatable {}
extension GitHubCommit: AutoEquatable {}
extension GitHubIssue: AutoEquatable {}
extension GitHubIssueLabel: AutoEquatable {}
