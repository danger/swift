@testable import Danger
import XCTest

final class GitHubTests: XCTestCase {
    private let dateFormatter = DateFormatter.defaultDateFormatter
    private var decoder: JSONDecoder!

    override func setUp() {
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
    }

    override func tearDown() {
        decoder = nil
    }

    func test_GitHubUser_decode() throws {
        guard let data = GitHubUserJSON.data(using: .utf8) else {
            XCTFail("Could not generate data")
            return
        }

        let correctUser = GitHubUser(id: 25_879_490, login: "yhkaplan", userType: .user)
        let testUser: GitHubUser = try JSONDecoder().decode(GitHubUser.self, from: data)

        XCTAssertEqual(testUser, correctUser)
    }

    func test_GitHubBot_decode() throws {
        guard let data = GitHubBotJSON.data(using: .utf8) else {
            XCTFail("Could not generate data")
            return
        }

        let correctUser = GitHubUser(id: 27_856_297, login: "dependabot-preview[bot]", userType: .bot)
        let testBot = try JSONDecoder().decode(GitHubUser.self, from: data)

        XCTAssertEqual(testBot, correctUser)
    }

    func test_GitHubMilestone_decodeWithSomeParameters() throws {
        guard let data = GitHubMilestoneJSONWithSomeParameters.data(using: .utf8),
            let createdAt = dateFormatter.date(from: "2018-01-20T16:29:28Z"),
            let updatedAt = dateFormatter.date(from: "2018-02-27T06:23:58Z") else {
            XCTFail("Could not generate data")
            return
        }

        let creator = GitHubUser(id: 739_696, login: "rnystrom", userType: .user)
        let correctMilestone = GitHubMilestone(id: 3_050_458,
                                               number: 11,
                                               state: .open,
                                               title: "1.19.0",
                                               description: nil,
                                               creator: creator,
                                               openIssues: 0,
                                               closedIssues: 2,
                                               createdAt: createdAt,
                                               updatedAt: updatedAt,
                                               closedAt: nil,
                                               dueOn: nil)

        let testMilestone: GitHubMilestone = try decoder.decode(GitHubMilestone.self, from: data)

        XCTAssertEqual(testMilestone, correctMilestone)
    }

    func test_GitHubMilestone_decodeWithAllParameters() throws {
        guard let data = GitHubMilestoneJSONWithAllParameters.data(using: .utf8),
            let createdAt = dateFormatter.date(from: "2018-01-20T16:29:28Z"),
            let updatedAt = dateFormatter.date(from: "2018-02-27T06:23:58Z"),
            let closedAt = dateFormatter.date(from: "2018-03-20T09:46:21Z"),
            let dueOn = dateFormatter.date(from: "2018-03-27T07:10:01Z") else {
            XCTFail("Could not generate data")
            return
        }

        let creator = GitHubUser(id: 739_696, login: "rnystrom", userType: .user)
        let correctMilestone = GitHubMilestone(id: 3_050_458,
                                               number: 11,
                                               state: .open,
                                               title: "1.19.0",
                                               description: "kdsjfls",
                                               creator: creator,
                                               openIssues: 0,
                                               closedIssues: 2,
                                               createdAt: createdAt,
                                               updatedAt: updatedAt,
                                               closedAt: closedAt,
                                               dueOn: dueOn)

        let testMilestone: GitHubMilestone = try decoder.decode(GitHubMilestone.self, from: data)

        XCTAssertEqual(testMilestone, correctMilestone)
    }

    func test_GitHubTeam_decode() throws {
        guard let data = GitHubTeamJSON.data(using: .utf8) else {
            XCTFail("Could not generate data")
            return
        }

        let correctTeam = GitHubTeam(id: 1, name: "Justice League")

        let testTeam = try decoder.decode(GitHubTeam.self, from: data)

        XCTAssertEqual(testTeam, correctTeam)
    }

    func test_GitHubMergeRef_decode() throws {
        guard let data = GitHubPRJSON.data(using: .utf8) else {
            XCTFail("Could not generate data")
            return
        }

        let user = GitHubUser(id: 1, login: "octocat", userType: .user)
        let repo = GitHubRepo(id: 1_296_269,
                              name: "Hello-World",
                              fullName: "octocat/Hello-World",
                              owner: user,
                              isPrivate: false,
                              description: "This your first repo!",
                              isFork: true,
                              htmlURL: "https://github.com/octocat/Hello-World")

        let correctMergeRef = GitHubMergeRef(label: "new-topic",
                                             ref: "new-topic1",
                                             sha: "6dcb09b5b57875f334f61aebed695e2e4193db5e",
                                             user: user,
                                             repo: repo)

        let testPR = try decoder.decode(GitHubPR.self, from: data)

        XCTAssertEqual(testPR.head, correctMergeRef)
    }

    func test_GitHubRepo_decode() throws {
        guard let data = GitHubRepoJSON.data(using: .utf8) else {
            XCTFail("Could not generate data")
            return
        }

        let user = GitHubUser(id: 1, login: "octocat", userType: .user)
        let correctRepo = GitHubRepo(id: 1_296_269,
                                     name: "Hello-World",
                                     fullName: "octocat/Hello-World",
                                     owner: user,
                                     isPrivate: false,
                                     description: "This your first repo!",
                                     isFork: false,
                                     htmlURL: "https://github.com/octocat/Hello-World")

        let testRepo = try decoder.decode(GitHubRepo.self, from: data)

        XCTAssertEqual(testRepo, correctRepo)
    }

    func test_GitHubReview_decode() throws {}

    func test_GitHubCommit_decode() throws {}

    func test_GitHubIssueLabel_decode() throws {}

    func test_GitHubIssue_decode() throws {
        guard let data = GitHubIssueJSON.data(using: .utf8) else {
            XCTFail("Could not generate data")
            return
        }

        let user = GitHubUser(id: 2_538_074, login: "davdroman", userType: .user)
        let correctIssue = GitHubIssue(
            id: 447_357_592,
            number: 96,
            title: "Some commit that modifies a Swift file",
            user: user,
            state: .closed,
            isLocked: false,
            body: "Some body for the issue",
            commentCount: 1,
            assignee: nil,
            assignees: [],
            milestone: nil,
            createdAt: Date(timeIntervalSince1970: 1_558_561_570),
            updatedAt: Date(timeIntervalSince1970: 1_558_566_949),
            closedAt: Date(timeIntervalSince1970: 1_558_566_946),
            labels: []
        )

        let testIssue = try decoder.decode(GitHubIssue.self, from: data)

        XCTAssertEqual(testIssue, correctIssue)
    }

    func test_GitHubIssue_emptyBody_decode() throws {
        guard let data = GitHubEmptyBodyIssueJSON.data(using: .utf8) else {
            XCTFail("Could not generate data")
            return
        }

        let user = GitHubUser(id: 2_538_074, login: "davdroman", userType: .user)
        let correctIssue = GitHubIssue(
            id: 447_357_592,
            number: 96,
            title: "Some commit that modifies a Swift file",
            user: user,
            state: .closed,
            isLocked: false,
            body: nil,
            commentCount: 1,
            assignee: nil,
            assignees: [],
            milestone: nil,
            createdAt: Date(timeIntervalSince1970: 1_558_561_570),
            updatedAt: Date(timeIntervalSince1970: 1_558_566_949),
            closedAt: Date(timeIntervalSince1970: 1_558_566_946),
            labels: []
        )

        let testIssue = try decoder.decode(GitHubIssue.self, from: data)

        XCTAssertEqual(testIssue, correctIssue)
    }

    func test_GitHubPR_decode() throws {}

    func test_GitHub_decode() throws {}
}
