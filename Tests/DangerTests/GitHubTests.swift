@testable import Danger
import DangerFixtures
import XCTest

// swiftlint:disable function_body_length type_body_length
final class GitHubTests: XCTestCase {
    private var dateFormatter: DateFormatter {
        DateFormatter.defaultDateFormatter
    }

    private var decoder: JSONDecoder!

    override func setUp() {
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
    }

    override func tearDown() {
        decoder = nil
        super.tearDown()
    }

    func test_GitHubUser_decode() throws {
        let data = Data(GitHubUserJSON.utf8)
        let correctUser = GitHub.User(id: 25_879_490, login: "yhkaplan", userType: .user)
        let testUser: GitHub.User = try JSONDecoder().decode(GitHub.User.self, from: data)

        XCTAssertEqual(testUser, correctUser)
    }

    func test_GitHubBot_decode() throws {
        let data = Data(GitHubBotJSON.utf8)
        let correctUser = GitHub.User(id: 27_856_297, login: "dependabot-preview[bot]", userType: .bot)
        let testBot = try JSONDecoder().decode(GitHub.User.self, from: data)

        XCTAssertEqual(testBot, correctUser)
    }

    func test_GitHubMilestone_decodeWithSomeParameters() throws {
        let data = Data(GitHubMilestoneJSONWithSomeParameters.utf8)
        let createdAt = Date(timeIntervalSince1970: 1_516_465_768.0)
        let updatedAt = Date(timeIntervalSince1970: 1_519_712_638.0)
        let creator = GitHub.User(id: 739_696, login: "rnystrom", userType: .user)
        let correctMilestone = GitHub.Milestone(id: 3_050_458,
                                                number: 11,
                                                state: .open,
                                                title: "1.19.0",
                                                description: "kdsjfls",
                                                creator: creator,
                                                openIssues: 0,
                                                closedIssues: 2,
                                                createdAt: createdAt,
                                                updatedAt: updatedAt,
                                                closedAt: nil,
                                                dueOn: nil)

        let testMilestone: GitHub.Milestone = try decoder.decode(GitHub.Milestone.self, from: data)

        XCTAssertEqual(testMilestone, correctMilestone)
    }

    func test_GitHubMilestone_decodeWithAllParameters() throws {
        let data = Data(GitHubMilestoneJSONWithAllParameters.utf8)
        let createdAt = Date(timeIntervalSince1970: 1_516_465_768.0)
        let updatedAt = Date(timeIntervalSince1970: 1_519_712_638.0)
        let closedAt = Date(timeIntervalSince1970: 1_521_539_181.0)
        let dueOn = Date(timeIntervalSince1970: 1_522_134_601.0)
        let creator = GitHub.User(id: 739_696, login: "rnystrom", userType: .user)
        let correctMilestone = GitHub.Milestone(id: 3_050_458,
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

        let testMilestone: GitHub.Milestone = try decoder.decode(GitHub.Milestone.self, from: data)

        XCTAssertEqual(testMilestone, correctMilestone)
    }

    func test_GitHubMilestone_decodeWithoutDescription() throws {
        let data = Data(GitHubMilestoneJSONWithoutDescription.utf8)
        let createdAt = Date(timeIntervalSince1970: 1_516_465_768.0)
        let updatedAt = Date(timeIntervalSince1970: 1_519_712_638.0)
        let creator = GitHub.User(id: 739_696, login: "rnystrom", userType: .user)
        let correctMilestone = GitHub.Milestone(id: 3_050_458,
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

        let testMilestone: GitHub.Milestone = try decoder.decode(GitHub.Milestone.self, from: data)

        XCTAssertEqual(testMilestone, correctMilestone)
    }

    func test_GitHubTeam_decode() throws {
        let data = Data(GitHubTeamJSON.utf8)
        let correctTeam = GitHub.Team(id: 1, name: "Justice League")

        let testTeam = try decoder.decode(GitHub.Team.self, from: data)

        XCTAssertEqual(testTeam, correctTeam)
    }

    func test_GitHubMergeRef_decode() throws {
        let data = Data(GitHubPRJSON.utf8)

        let user = GitHub.User(id: 1, login: "octocat", userType: .user)
        let repo = GitHub.Repo(id: 1_296_269,
                               name: "Hello-World",
                               fullName: "octocat/Hello-World",
                               owner: user,
                               isPrivate: false,
                               description: "This your first repo!",
                               isFork: true,
                               htmlURL: "https://github.com/octocat/Hello-World")

        let correctMergeRef = GitHub.MergeRef(label: "new-topic",
                                              ref: "new-topic1",
                                              sha: "6dcb09b5b57875f334f61aebed695e2e4193db5e",
                                              user: user,
                                              repo: repo)

        let testPR = try decoder.decode(GitHub.PullRequest.self, from: data)

        XCTAssertEqual(testPR.head, correctMergeRef)
    }

    func test_GitHubRepo_decode() throws {
        let user = GitHub.User(id: 1, login: "octocat", userType: .user)
        let correctRepo = GitHub.Repo(id: 1_296_269,
                                      name: "Hello-World",
                                      fullName: "octocat/Hello-World",
                                      owner: user,
                                      isPrivate: false,
                                      description: "This your first repo!",
                                      isFork: false,
                                      htmlURL: "https://github.com/octocat/Hello-World")

        let testRepo = try decoder.decode(GitHub.Repo.self, from: Data(GitHubRepoJSON.utf8))

        XCTAssertEqual(testRepo, correctRepo)
    }

    func test_GitHubReview_decode() throws {
        let testReviews = try decoder.decode([GitHub.Review].self, from: Data(GitHubReviews.utf8))

        XCTAssertEqual(testReviews, [
            .init(body: "",
                  commitId: "c2dd12f6f1b54fa7a8ce89a0ac2d116a5d4d81c7",
                  id: 172_114_916,
                  state: .approved,
                  submittedAt: Date(timeIntervalSince1970: 1_541_522_564.0),
                  user: .init(id: 49038,
                              login: "orta",
                              userType: .user)),
            .init(body: "",
                  commitId: "c2dd12f6f1b54fa7a8ce89a0ac2d116a5d4d81c7",
                  id: 172_121_815,
                  state: .comment,
                  submittedAt: Date(timeIntervalSince1970: 1_541_523_134.0),
                  user: .init(id: 36_844_464,
                              login: "KITSFrancoMeloni",
                              userType: .user)),
            .init(body: "",
                  commitId: "c2dd12f6f1b54fa7a8ce89a0ac2d116a5d4d81c7",
                  id: 172_123_782,
                  state: .comment,
                  submittedAt: Date(timeIntervalSince1970: 1_541_523_347.0),
                  user: .init(id: 17_830_956,
                              login: "f-meloni",
                              userType: .user)),
        ])
    }

    func test_GitHubCommit_decode() throws {}

    func test_GitHubIssueLabel_decode() throws {}

    func test_GitHubIssue_decode() throws {
        let data = Data(GitHubIssueJSON.utf8)

        let user = GitHub.User(id: 2_538_074, login: "davdroman", userType: .user)
        let correctIssue = GitHub.Issue(
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

        let testIssue = try decoder.decode(GitHub.Issue.self, from: data)

        XCTAssertEqual(testIssue, correctIssue)
    }

    func test_GitHubIssue_emptyBody_decode() throws {
        let data = Data(GitHubEmptyBodyIssueJSON.utf8)

        let user = GitHub.User(id: 2_538_074, login: "davdroman", userType: .user)
        let correctIssue = GitHub.Issue(
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

        let testIssue = try decoder.decode(GitHub.Issue.self, from: data)

        XCTAssertEqual(testIssue, correctIssue)
    }

    func test_GitHubCommit_decodesJSONWithEmptyAuthor() throws {
        let data = Data(GitHubCommitWithEmptyAuthorJSON.utf8)
        let expectedAuthor = Git.Commit.Author(name: "Franco Meloni", email: "franco.meloni91@gmail.com", date: "2019-04-20T17:46:50Z")

        let testCommit = try decoder.decode(GitHub.Commit.self, from: data)

        XCTAssertNil(testCommit.author)
        XCTAssertEqual(testCommit.sha, "cad494648f773cd4fad5a9ea948c1bfabf36032a")
        XCTAssertEqual(testCommit.url, "https://api.github.com/repos/danger/swift/commits/cad494648f773cd4fad5a9ea948c1bfabf36032a")
        XCTAssertEqual(testCommit.commit, GitHub.Commit.CommitData(sha: nil,
                                                                   author: expectedAuthor,
                                                                   committer: expectedAuthor,
                                                                   message: "Re use the same executor on the runner",
                                                                   parents: nil,
                                                                   url: "https://api.github.com/repos/danger/swift/git/commits/cad494648f773cd4fad5a9ea948c1bfabf36032a"))
        XCTAssertEqual(testCommit.committer, GitHub.User(id: 17_830_956, login: "f-meloni", userType: .user))
    }

    func test_GitHubPR_decode() throws {
        let data = Data(GitHubPRJSON.utf8)
        let actualPR = try decoder.decode(GitHub.PullRequest.self, from: data)

        let expectedUser = GitHub.User(
            id: 1,
            login: "octocat",
            userType: .user
        )

        let repo = GitHub.Repo(
            id: 1_296_269,
            name: "Hello-World",
            fullName: "octocat/Hello-World",
            owner: expectedUser,
            isPrivate: false,
            description: "This your first repo!",
            isFork: true,
            htmlURL: "https://github.com/octocat/Hello-World"
        )

        let head = GitHub.MergeRef(
            label: "new-topic",
            ref: "new-topic1",
            sha: "6dcb09b5b57875f334f61aebed695e2e4193db5e",
            user: expectedUser,
            repo: repo
        )

        let base = GitHub.MergeRef(
            label: "master",
            ref: "master",
            sha: "6dcb09b5b57875f334f61aebed695e2e4193db5e",
            user: expectedUser, repo: repo
        )

        let milestone = GitHub.Milestone(
            id: 1_002_604,
            number: 1,
            state: GitHub.Milestone.State.open,
            title: "v1.0",
            description: "Tracking milestone for version 1.0",
            creator: expectedUser,
            openIssues: 4,
            closedIssues: 8,
            createdAt: Date(timeIntervalSince1970: 1_302_466_171.0),
            updatedAt: Date(timeIntervalSince1970: 1_393_873_090.0),
            closedAt: Date(timeIntervalSince1970: 1_360_675_321.0),
            dueOn: Date(timeIntervalSince1970: 1_349_825_941.0)
        )

        let label = GitHub.Label(
            id: 208045946,
            url: "https://api.github.com/repos/octocat/Hello-World/labels/bug",
            name: "bug",
            color: "f29513"
        )

        let expectedPR = GitHub.PullRequest(
            number: 1347,
            title: "new-feature",
            body: "Please pull these awesome changes",
            user: expectedUser,
            assignee: expectedUser,
            assignees: nil,
            createdAt: Date(timeIntervalSince1970: 1_296_068_472.0),
            updatedAt: Date(timeIntervalSince1970: 1_296_068_472.0),
            closedAt: Date(timeIntervalSince1970: 1_296_068_472.0),
            mergedAt: Date(timeIntervalSince1970: 1_296_068_472.0),
            head: head,
            base: base,
            state: GitHub.PullRequest.PullRequestState.open,
            isLocked: true,
            isMerged: nil,
            commitCount: nil,
            commentCount: nil,
            reviewCommentCount: nil,
            additions: nil,
            deletions: nil,
            changedFiles: nil,
            milestone: milestone,
            htmlUrl: "https://github.com/octocat/Hello-World/pull/1347",
            draft: false,
            links: GitHub.PullRequest.Link(
                self: "https://api.github.com/repos/octocat/Hello-World/pulls/1347",
                html: "https://github.com/octocat/Hello-World/pull/1347",
                issue: "https://api.github.com/repos/octocat/Hello-World/issues/1347",
                comments: "https://api.github.com/repos/octocat/Hello-World/issues/1347/comments",
                reviewComments: "https://api.github.com/repos/octocat/Hello-World/pulls/1347/comments",
                reviewComment: "https://api.github.com/repos/octocat/Hello-World/pulls/comments{/number}",
                commits: "https://api.github.com/repos/octocat/Hello-World/pulls/1347/commits",
                statuses: "https://api.github.com/repos/octocat/Hello-World/statuses/6dcb09b5b57875f334f61aebed695e2e4193db5e"
            ),
            labels: [label]
        )

        XCTAssertEqual(expectedPR, actualPR)
    }
}
