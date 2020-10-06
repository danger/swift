@testable import Danger
import DangerFixtures
import XCTest

final class GitLabTests: XCTestCase {
    private var gitLab: GitLab {
        gitlabFixtureDSL.gitLab
    }

    func testParsesMergeRequest() {
        let mergeRequest = gitLab.mergeRequest
        let fmeloni = GitLab.User(avatarUrl: "https://secure.gravatar.com/avatar/3d90e967de2beab6d44cfadbb4976b87?s=80&d=identicon", id: 3_331_525,
                                  name: "Franco Meloni",
                                  state: .active,
                                  username: "f-meloni",
                                  webUrl: "https://gitlab.com/f-meloni")
        let expectedTimeStats = GitLab.MergeRequest.TimeStats(humanTimeEstimate: nil,
                                                              humanTimeSpent: nil,
                                                              timeEstimate: 0,
                                                              totalTimeSpent: 0)
        let orta = GitLab.User(avatarUrl: "https://secure.gravatar.com/avatar/f116cb3be23153ec08b94e8bd4dbcfeb?s=80&d=identicon",
                               id: 377_669,
                               name: "Orta",
                               state: .active,
                               username: "orta",
                               webUrl: "https://gitlab.com/orta")
        let expectedMilestone = GitLab.MergeRequest.Milestone(createdAt: Date(timeIntervalSince1970: 1_554_933_465.346),
                                                              description: "Test Description",
                                                              dueDate: Date(timeIntervalSince1970: 1_560_124_800.0),
                                                              id: 1,
                                                              iid: 2,
                                                              projectId: 1000,
                                                              startDate: Date(timeIntervalSince1970: 1_554_854_400.0),
                                                              state: .closed,
                                                              title: "Test Milestone",
                                                              updatedAt: Date(timeIntervalSince1970: 1_554_933_465.346),
                                                              webUrl: "https://gitlab.com/milestone")

        let expectedPipeline = GitLab.MergeRequest.Pipeline(id: 50,
                                                            ref: "ef28580bb2a00d985bffe4a4ce3fe09fdb12283f",
                                                            sha: "621bc3348549e51c5bd6ea9f094913e9e4667c7b",
                                                            status: .success,
                                                            webUrl: "https://gitlab.com/danger-systems/danger.systems/pipeline/621bc3348549e51c5bd6ea9f094913e9e4667c7b")
        let expectedDiffRefs = GitLab.MergeRequest.DiffRefs(baseSha: "ef28580bb2a00d985bffe4a4ce3fe09fdb12283f", headSha: "621bc3348549e51c5bd6ea9f094913e9e4667c7b", startSha: "ef28580bb2a00d985bffe4a4ce3fe09fdb12283f")

        XCTAssertEqual(mergeRequest.allowCollaboration, false)
        XCTAssertEqual(mergeRequest.allowMaintainerToPush, false)
        XCTAssertEqual(mergeRequest.approvalsBeforeMerge, 1)
        XCTAssertEqual(mergeRequest.assignee, orta)
        XCTAssertEqual(mergeRequest.assignees?.first, orta)
        XCTAssertEqual(mergeRequest.author, fmeloni)
        XCTAssertEqual(mergeRequest.changesCount, "1")
        XCTAssertNil(mergeRequest.closedAt)
        XCTAssertNil(mergeRequest.closedBy)
        XCTAssertEqual(mergeRequest.description, "Updating it to avoid problems like https://github.com/danger/swift/issues/221")
        XCTAssertEqual(mergeRequest.diffRefs, expectedDiffRefs)
        XCTAssertEqual(mergeRequest.downvotes, 0)
        XCTAssertEqual(mergeRequest.firstDeployedToProductionAt, Date(timeIntervalSince1970: 1_554_942_622.492))
        XCTAssertEqual(mergeRequest.forceRemoveSourceBranch, true)
        XCTAssertEqual(mergeRequest.id, 27_469_633)
        XCTAssertEqual(mergeRequest.iid, 182)
        XCTAssertEqual(mergeRequest.latestBuildFinishedAt, Date(timeIntervalSince1970: 1_554_942_802.492))
        XCTAssertEqual(mergeRequest.latestBuildStartedAt, Date(timeIntervalSince1970: 1_554_942_022.492))
        XCTAssertEqual(mergeRequest.labels, [])
        XCTAssertEqual(mergeRequest.mergeCommitSha, "377a24fb7a0f30364f089f7bca67752a8b61f477")
        XCTAssertEqual(mergeRequest.mergedAt, Date(timeIntervalSince1970: 1_554_943_042.492))
        XCTAssertEqual(mergeRequest.mergedBy, orta)
        XCTAssertEqual(mergeRequest.mergeOnPipelineSuccess, false)
        XCTAssertEqual(mergeRequest.milestone, expectedMilestone)
        XCTAssertEqual(mergeRequest.pipeline, expectedPipeline)
        XCTAssertEqual(mergeRequest.projectId, 1_620_437)
        XCTAssertEqual(mergeRequest.sha, "621bc3348549e51c5bd6ea9f094913e9e4667c7b")
        XCTAssertNil(mergeRequest.shouldRemoveSourceBranch)
        XCTAssertEqual(mergeRequest.sourceBranch, "patch-2")
        XCTAssertEqual(mergeRequest.sourceProjectId, 10_132_593)
        XCTAssertEqual(mergeRequest.state, .merged)
        XCTAssertEqual(mergeRequest.subscribed, false)
        XCTAssertEqual(mergeRequest.targetBranch, "master")
        XCTAssertEqual(mergeRequest.targetProjectId, 1_620_437)
        XCTAssertEqual(mergeRequest.timeStats, expectedTimeStats)
        XCTAssertEqual(mergeRequest.title, "Update getting_started.html.slim")
        XCTAssertEqual(mergeRequest.upvotes, 0)
        XCTAssertEqual(mergeRequest.userCanMerge, false)
        XCTAssertEqual(mergeRequest.userNotesCount, 0)
        XCTAssertEqual(mergeRequest.workInProgress, false)
        XCTAssertEqual(mergeRequest.webUrl, "https://gitlab.com/danger-systems/danger.systems/merge_requests/182")
    }

    func testParsesCorrectlyMetadata() {
        let metadata = gitLab.metadata

        XCTAssertEqual(metadata.pullRequestID, "182")
        XCTAssertEqual(metadata.repoSlug, "danger-systems/danger.systems")
    }

    func testMilestoneWithoutDueDate() {
        let gitLab = gitlabWithoutMilestoneDateRangeFixtureDSL.gitLab

        XCTAssertNil(gitLab?.mergeRequest.milestone?.dueDate)
    }
}
