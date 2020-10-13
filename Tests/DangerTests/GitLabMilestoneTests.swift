@testable import Danger
import DangerFixtures
import XCTest

class GitLabMilestoneTests: XCTestCase {
    func testParseGroupMilestone() {
        let jsonString = DSLGitLabGroupMilestoneJSON
        let data = Data(jsonString.utf8)

        do {
            let milestone = try jsonDecoder.decode(GitLab.MergeRequest.Milestone.self, from: data)
            XCTAssertEqual(milestone.groupId, 9_449_452)
            XCTAssertNil(milestone.projectId)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testParseProjectMilestone() {
        let jsonString = DSLGitLabProjectMilestoneJSON
        let data = Data(jsonString.utf8)

        do {
            let milestone = try jsonDecoder.decode(GitLab.MergeRequest.Milestone.self, from: data)
            XCTAssertEqual(milestone.projectId, 21_265_694)
            XCTAssertNil(milestone.groupId)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    private var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom(DateFormatter.dateFormatterHandler)
        return decoder
    }
}
