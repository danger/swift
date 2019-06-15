@testable import Danger
import DangerFixtures
import XCTest

final class GitLabTests: XCTestCase {
    private var gitLab: GitLab {
        return gitlabFixtureDSL.gitLab
    }

    func testParsesMergeRequest() {
        let mergeRequest = gitLab.mergeRequest
        let fmeloni = GitLabUser(id: 3_331_525,
                                 name: "Franco Meloni",
                                 username: "f-meloni",
                                 state: .active,
                                 avatarUrl: "https://secure.gravatar.com/avatar/3d90e967de2beab6d44cfadbb4976b87?s=80&d=identicon",
                                 webUrl: "https://gitlab.com/f-meloni")
        let expectedTimeStats = GitLabMergeRequest.TimeStats(timeEstimate: 0,
                                                             totalTimeSpent: 0,
                                                             humanTimeEstimate: nil,
                                                             humanTimeSpent: nil)
        let orta = GitLabUser(id: 377_669,
                              name: "Orta",
                              username: "orta",
                              state: .active,
                              avatarUrl: "https://secure.gravatar.com/avatar/f116cb3be23153ec08b94e8bd4dbcfeb?s=80&d=identicon",
                              webUrl: "https://gitlab.com/orta")

        let expectedMilestone = GitLabMergeRequest.Milestone(id: 1,
                                                             iid: 2,
                                                             projectId: 1000,
                                                             title: "Test Milestone",
                                                             description: "Test Description",
                                                             state: .closed,
                                                             createdAt: Date(timeIntervalSince1970: 1_554_933_465.346),
                                                             updatedAt: Date(timeIntervalSince1970: 1_554_933_465.346),
                                                             dueDate: Date(timeIntervalSince1970: 1_560_124_800.0),
                                                             startDate: Date(timeIntervalSince1970: 1_554_933_465.346),
                                                             webUrl: "https://gitlab.com/milestone")

        let expectedPipeline = GitLabMergeRequest.Pipeline(id: 50, sha: "621bc3348549e51c5bd6ea9f094913e9e4667c7b",
                                                           ref: "ef28580bb2a00d985bffe4a4ce3fe09fdb12283f",
                                                           status: .success,
                                                           webUrl: "https://gitlab.com/danger-systems/danger.systems/pipeline/621bc3348549e51c5bd6ea9f094913e9e4667c7b")

        XCTAssertEqual(mergeRequest.assignee, orta)
        XCTAssertEqual(mergeRequest.id, 27_469_633)
        XCTAssertEqual(mergeRequest.iid, 182)
        XCTAssertEqual(mergeRequest.projectId, 1_620_437)
        XCTAssertEqual(mergeRequest.projectId, 1_620_437)
        XCTAssertEqual(mergeRequest.title, "Update getting_started.html.slim")
        XCTAssertEqual(mergeRequest.description, "Updating it to avoid problems like https://github.com/danger/swift/issues/221")
        XCTAssertEqual(mergeRequest.state, .merged)
        XCTAssertEqual(mergeRequest.sourceBranch, "patch-2")
        XCTAssertEqual(mergeRequest.targetBranch, "master")
        XCTAssertEqual(mergeRequest.upvotes, 0)
        XCTAssertEqual(mergeRequest.downvotes, 0)
        XCTAssertEqual(mergeRequest.author, fmeloni)
        XCTAssertEqual(mergeRequest.sourceProjectId, 10_132_593)
        XCTAssertEqual(mergeRequest.targetProjectId, 1_620_437)
        XCTAssertEqual(mergeRequest.labels, [])
        XCTAssertEqual(mergeRequest.workInProgress, false)
        XCTAssertEqual(mergeRequest.milestone, expectedMilestone)
        XCTAssertEqual(mergeRequest.mergeOnPipelineSuccess, false)
        XCTAssertEqual(mergeRequest.sha, "621bc3348549e51c5bd6ea9f094913e9e4667c7b")
        XCTAssertEqual(mergeRequest.userNotesCount, 0)
        XCTAssertEqual(mergeRequest.mergeCommitSha, "377a24fb7a0f30364f089f7bca67752a8b61f477")
        XCTAssertNil(mergeRequest.shouldRemoveSourceBranch)
        XCTAssertEqual(mergeRequest.forceRemoveSourceBranch, true)
        XCTAssertEqual(mergeRequest.allowCollaboration, false)
        XCTAssertEqual(mergeRequest.allowMaintainerToPush, false)
        XCTAssertEqual(mergeRequest.webUrl, "https://gitlab.com/danger-systems/danger.systems/merge_requests/182")
        XCTAssertEqual(mergeRequest.timeStats, expectedTimeStats)
        XCTAssertEqual(mergeRequest.subscribed, false)
        XCTAssertEqual(mergeRequest.changesCount, "1")
        XCTAssertEqual(mergeRequest.mergedBy, orta)
        XCTAssertEqual(mergeRequest.mergedAt, Date(timeIntervalSince1970: 1_554_943_042.492))
        XCTAssertNil(mergeRequest.closedBy)
        XCTAssertNil(mergeRequest.closedAt)
        XCTAssertEqual(mergeRequest.userCanMerge, false)
        XCTAssertEqual(mergeRequest.pipeline, expectedPipeline)
        XCTAssertEqual(mergeRequest.latestBuildStartedAt, Date(timeIntervalSince1970: 1_554_942_022.492))
        XCTAssertEqual(mergeRequest.latestBuildFinishedAt, Date(timeIntervalSince1970: 1_554_942_802.492))
    }

    func testParsesCorrectlyMetadata() {
        let metadata = gitLab.metadata

        XCTAssertEqual(metadata.pullRequestID, "182")
        XCTAssertEqual(metadata.repoSlug, "danger-systems/danger.systems")
    }
}
