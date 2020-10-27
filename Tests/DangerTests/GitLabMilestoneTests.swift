@testable import Danger
import DangerFixtures
import XCTest

final class GitLabMilestoneTests: XCTestCase {
    func testParseGroupMilestone() throws {
        let jsonString = DSLGitLabGroupMilestoneJSON
        let data = Data(jsonString.utf8)

        let milestone = try jsonDecoder.decode(GitLab.MergeRequest.Milestone.self, from: data)
        XCTAssertTrue(milestone.parent.isGroup)
        XCTAssertEqual(milestone.parent.id, 9_449_452)
    }

    func testParseProjectMilestone() throws {
        let jsonString = DSLGitLabProjectMilestoneJSON
        let data = Data(jsonString.utf8)

        let milestone = try jsonDecoder.decode(GitLab.MergeRequest.Milestone.self, from: data)
        XCTAssertTrue(milestone.parent.isProject)
        XCTAssertEqual(milestone.parent.id, 21_265_694)
    }

    func testParseMilestoneFailure() throws {
        let jsonString = "{}"
        let data = Data(jsonString.utf8)

        XCTAssertThrowsError(
            try jsonDecoder.decode(
                GitLab.MergeRequest.Milestone.self,
                from: data
            )
        )
    }

    private var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom(DateFormatter.dateFormatterHandler)
        return decoder
    }
}
