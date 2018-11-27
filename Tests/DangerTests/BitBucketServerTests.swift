@testable import Danger
import XCTest

final class BitBucketServerTests: XCTestCase {
    private var decoder: JSONDecoder = JSONDecoder()
    private lazy var bitBucketServer: BitBucketServer = {
        let data = DSLBitBucketServerJSON.data(using: .utf8)!
        return try! decoder.decode(DSL.self, from: data).danger.bitbucketServer
    }()

    func testItParsesTheBitBucketPullRequest() {
        let pullRequest = bitBucketServer.pullRequest
        let expectedUser = BitBucketServerUser(id: 1, name: "test", displayName: "test", emailAddress: "user@email.com", active: true, slug: "test", type: "NORMAL")
        XCTAssertEqual(pullRequest.author.user, expectedUser)

        let expectedProject = BitBucketServerProject(id: 1, key: "PROJ", name: "Project", isPublic: false, type: "NORMAL")
        let expectedRepo = BitBucketServerRepo(name: "Repo", slug: "repo", scmId: "git", isPublic: false, forkable: true, project: expectedProject)
        let expectedBase = BitBucketServerMergeRef(id: "refs/heads/foo", displayId: "foo", latestCommit: "d6725486c38d46a33e76f622cf24b9a388c8d13d", repository: expectedRepo)
        XCTAssertEqual(pullRequest.fromRef, expectedBase)

        let expectedHead = BitBucketServerMergeRef(id: "refs/heads/master", displayId: "master", latestCommit: "8942a1f75e4c95df836f19ef681d20a87da2ee20", repository: expectedRepo)
        XCTAssertEqual(pullRequest.toRef, expectedHead)

        let expectedPartecipant = BitBucketServerUser(id: 2, name: "danger", displayName: "DangerCI", emailAddress: "user@email.com", active: true, slug: "danger", type: "NORMAL")
        XCTAssertEqual(pullRequest.participants.count, 1)
        XCTAssertEqual(pullRequest.participants.first?.user, expectedPartecipant)

        XCTAssertEqual(pullRequest.closed, false)
        XCTAssertEqual(pullRequest.createdAt, 1_518_863_923_273)
        XCTAssertEqual(pullRequest.isLocked, false)
        XCTAssertEqual(pullRequest.open, true)
        XCTAssertEqual("OPEN", pullRequest.state)
        XCTAssertEqual("Pull request title", pullRequest.title)
    }

    func testItParsesTheBitBucketCommits() {
        let commits = bitBucketServer.commits
        let expectedUser = BitBucketServerUser(id: 2, name: "danger", displayName: "DangerCI", emailAddress: "foo@bar.com", active: true, slug: "danger", type: "NORMAL")
        let expectedParent = BitBucketServerCommit.BitBucketServerCommitParent(id: "c62ada76533a2de045d4c6062988ba84df140729", displayId: "c62ada76533")
        let expectedCommit = BitBucketServerCommit(id: "d6725486c38d46a33e76f622cf24b9a388c8d13d",
                                                   displayId: "d6725486c38",
                                                   author: expectedUser,
                                                   authorTimestamp: 1_519_442_341_000,
                                                   committer: expectedUser,
                                                   committerTimestamp: 1_519_442_341_000,
                                                   message: "Modify and remove files",
                                                   parents: [expectedParent])
        XCTAssertEqual(commits.first, expectedCommit)
        XCTAssertEqual(commits.count, 2)
    }

    func testItParsesTheBitBucketComments() {
        let comments = bitBucketServer.comments
        let expectedUser = BitBucketServerUser(id: 2, name: "danger", displayName: "DangerCI", emailAddress: "foo@bar.com", active: true, slug: "danger", type: "NORMAL")
        let commentText = "Text"
        let expectedProperty = BitBucketServerComment.CommentDetail.InnerProperties(repositoryId: 1, issues: nil)
        let expectedCommentDetail = BitBucketServerComment.CommentDetail(id: 10, version: 23, text: commentText, author: expectedUser, createdAt: 1_518_939_353_345, updatedAt: 1_519_449_132_488, comments: [], properties: expectedProperty, tasks: [])
        let expectedComment = BitBucketServerComment(id: 52, createdAt: 1_518_939_353_345, user: expectedUser, action: "COMMENTED", fromHash: nil, previousFromHash: nil, toHash: nil, previousToHash: nil, commentAction: "ADDED", comment: expectedCommentDetail)

        XCTAssertEqual(comments[1], expectedComment)
        XCTAssertEqual(comments.count, 7)
    }

    func testItParsesTheBitBucketMetadata() {
        let metadata = bitBucketServer.metadata
        XCTAssertEqual(metadata.repoSlug, "artsy/emission")
        XCTAssertEqual(metadata.pullRequestID, "327")
    }

    func testItParsesTheBitBucketActivities() {
        let activities = bitBucketServer.activities

        let expectedUser = BitBucketServerUser(id: 1, name: "test", displayName: "test", emailAddress: "foo@bar.com", active: true, slug: "test", type: "NORMAL")
        let expectedActivity = BitBucketServerActivity(id: 61, createdAt: 1_519_442_356_495, user: expectedUser, action: "RESCOPED", commentAction: nil)

        XCTAssertEqual(activities.first, expectedActivity)
        XCTAssertEqual(activities.count, 7)
    }
}
