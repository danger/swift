@testable import Danger
import DangerFixtures
import XCTest

final class BitBucketCloudTests: XCTestCase {
    private var bitbucketCould: BitBucketCloud {
        bitbucketCloudFixtureDSL.bitbucketCloud
    }

    func testParsesActivities() {
        let activities = bitbucketCould.activities

        XCTAssertEqual(activities, [
            BitBucketCloud.Activity(comment: nil),
            BitBucketCloud.Activity(comment: nil),
        ])
    }

    func testParsesComments() {
        let comments = bitbucketCould.comments

        XCTAssertEqual(comments, [
            BitBucketCloud.Comment(
                content: BitBucketCloud.Content(html: "<p>Test Comment</p>",
                                                markup: "markdown",
                                                raw: "Test Comment"),
                createdOn: Date(timeIntervalSince1970: 1_563_141_023.276),
                deleted: false,
                id: 109_197_958,
                inline: nil,
                type: "pullrequest_comment",
                updatedOn: Date(timeIntervalSince1970: 1_563_141_023.284),
                user: BitBucketCloud.User(
                    accountId: "557058:cac1aa4b-db5e-4c3a-8ba3-c4880b498de8",
                    displayName: "Franco Meloni",
                    nickname: "Zagolo",
                    uuid: "{bd1991e4-a3ed-45b2-be38-acea659650f1}"
                )
            ),
        ])
    }

    func testParsesCommits() {
        let commits = bitbucketCould.commits
        let expectedAuthor = BitBucketCloud.Commit.Author(raw: "Franco Meloni <franco.meloni91@gmail.com>",
                                                          user: BitBucketCloud.User(
                                                              accountId: "557058:cac1aa4b-db5e-4c3a-8ba3-c4880b498de8",
                                                              displayName: "Franco Meloni",
                                                              nickname: "f-meloni",
                                                              uuid: "{bd1991e4-a3ed-45b2-be38-acea659650f1}"
                                                          ))

        XCTAssertEqual(commits, [
            BitBucketCloud.Commit(
                author: expectedAuthor,
                date: Date(timeIntervalSince1970: 1_563_114_728.0),
                hash: "9ab48765728b309d88486a52bb57805fffe20410",
                message: "README.md edited online with Bitbucket"
            ),
        ])
    }
    
    func testCommitWithoutUser() {
        do {
            let commit = try JSONDecoder().decode(BitBucketCloud.Commit.self, from: Data(BitBucketCloudCommitWithoutUser.utf8))
            XCTAssertEqual(commit.author.raw, "foo@bar.com")
            XCTAssertNil(commit.author.user)
        } catch {
            XCTFail("Couldn't parse JSON commit (BitBucketCloudCommitWithoutUser) in BitbucketCloudCommit. \nError: \(error)")
        }
    }

    func testParsesMetadata() {
        let metadata = bitbucketCould.metadata

        XCTAssertEqual(metadata.pullRequestID, "1")
        XCTAssertEqual(metadata.repoSlug, "f-meloni/danger-kotlin")
    }

    func testParsesPR() {
        let pr = bitbucketCould.pr
        let source = pr.source
        let destination = pr.destination

        XCTAssertEqual(pr.author,
                       BitBucketCloud.User(
                           accountId: "557058:cac1aa4b-db5e-4c3a-8ba3-c4880b498de8",
                           displayName: "Franco Meloni",
                           nickname: "f-meloni",
                           uuid: "{bd1991e4-a3ed-45b2-be38-acea659650f1}"
                       ))
        XCTAssertEqual(pr.createdOn.timeIntervalSince1970, 1_563_114_729.45)
        XCTAssertEqual(pr.description, "README.md edited online with Bitbucket")
        XCTAssertEqual(destination.branchName, "master")
        XCTAssertEqual(destination.commitHash, "0f3153d8ba78")
        XCTAssertEqual(destination.repository, BitBucketCloud.Repo(
            fullName: "f-meloni/danger-kotlin",
            name: "danger-kotlin",
            uuid: "{37c7bd5b-887c-4450-99cb-3cab9c456f3d}"
        ))
        XCTAssertEqual(pr.id, 1)
        XCTAssertEqual(pr.participants, [])
        XCTAssertEqual(pr.reviewers, [])
        XCTAssertEqual(source.branchName, "Franco-Meloni/readmemd-edited-online-with-bitbucket-1563114726802")
        XCTAssertEqual(source.commitHash, "9ab48765728b")
        XCTAssertEqual(source.repository, BitBucketCloud.Repo(
            fullName: "f-meloni/danger-kotlin",
            name: "danger-kotlin",
            uuid: "{37c7bd5b-887c-4450-99cb-3cab9c456f3d}"
        ))
        XCTAssertEqual(pr.state, .open)
        XCTAssertEqual(pr.title, "README.md edited online with Bitbucket")
        XCTAssertEqual(pr.updatedOn.timeIntervalSince1970, 1_563_114_729.488)
    }
}
