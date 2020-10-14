@testable import Danger
import DangerFixtures
import XCTest

final class GitLabMilestoneTests: XCTestCase {
    func testParseGroupMilestone() throws {
        let jsonString = DSLGitLabGroupMilestoneJSON
        let data = Data(jsonString.utf8)

        let milestone = try jsonDecoder.decode(GitLab.MergeRequest.Milestone.self, from: data)
        XCTAssertEqual(milestone.groupId, 9_449_452)
        XCTAssertNil(milestone.projectId)
    }

    func testParseProjectMilestone() throws {
        let jsonString = DSLGitLabProjectMilestoneJSON
        let data = Data(jsonString.utf8)

        let milestone = try jsonDecoder.decode(GitLab.MergeRequest.Milestone.self, from: data)
        XCTAssertEqual(milestone.projectId, 21_265_694)
        XCTAssertNil(milestone.groupId)
    }

    private var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom(DateFormatter.dateFormatterHandler)
        return decoder
    }
}
