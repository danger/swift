@testable import Danger
import DangerFixtures
import XCTest

final class GitTests: XCTestCase {
    private var git: Git { githubFixtureDSL.git }

    private var decoder: JSONDecoder!

    func testDecodesCommits() {
        XCTAssertEqual(git.commits, [
            Git.Commit(
                sha: "93ae30cf2aee4241c442fb3242543490998cffdb",
                author: Git.Commit.Author(name: "Ash Furrow", email: "ash@ashfurrow.com", date: "2016-07-26T19:54:16Z"),
                committer: Git.Commit.Author(name: "Ash Furrow", email: "ash@ashfurrow.com", date: "2016-07-26T19:55:00Z"),
                message: "[Xcode] Updates for compatibility with Xcode 7.3.1.",
                parents: ["68c8db83776c1942145f530159a3fffddb812577"],
                url: "https://api.github.com/repos/artsy/eidolon/commits/93ae30cf2aee4241c442fb3242543490998cffdb"
            ),
            Git.Commit(
                sha: "4cf1e41f72516a4135f1738c47f7dd3d421ff3c4",
                author: Git.Commit.Author(name: "Ash Furrow", email: "ash@ashfurrow.com", date: "2016-07-26T19:55:53Z"),
                committer: Git.Commit.Author(name: "Ash Furrow", email: "ash@ashfurrow.com", date: "2016-07-26T19:55:53Z"),
                message: "[CI] Updates Travis to Xcode 7.3.",
                parents: ["93ae30cf2aee4241c442fb3242543490998cffdb"],
                url: "https://api.github.com/repos/artsy/eidolon/commits/4cf1e41f72516a4135f1738c47f7dd3d421ff3c4"
            ),
            Git.Commit(
                sha: "d0d72ec5b5ee90c2513a8aafb48911ae5bcdf4ac", author: Git.Commit.Author(name: "Ash Furrow", email: "ash@ashfurrow.com", date: "2016-07-26T21:17:40Z"),
                committer: Git.Commit.Author(name: "Ash Furrow", email: "ash@ashfurrow.com", date: "2016-07-26T21:17:40Z"),
                message: "[Deps] Updates dependencies for Swift 2.2.",
                parents: ["4cf1e41f72516a4135f1738c47f7dd3d421ff3c4"],
                url: "https://api.github.com/repos/artsy/eidolon/commits/d0d72ec5b5ee90c2513a8aafb48911ae5bcdf4ac"
            ),
            Git.Commit(
                sha: "c330e8dfc6ae553a98fb9ffa6347f87d9f00f864",
                author: Git.Commit.Author(name: "Ash Furrow", email: "ash@ashfurrow.com", date: "2016-08-15T20:41:00Z"),
                committer: Git.Commit.Author(name: "Ash Furrow", email: "ash@ashfurrow.com", date: "2016-08-15T20:41:00Z"),
                message: "[Tests] Cleans up snapshot tests for Xcode 7.3.1.",
                parents: ["d0d72ec5b5ee90c2513a8aafb48911ae5bcdf4ac"],
                url: "https://api.github.com/repos/artsy/eidolon/commits/c330e8dfc6ae553a98fb9ffa6347f87d9f00f864"
            ),
            Git.Commit(
                sha: "263d74a15e856f563f18864c459167c46c92cf48",
                author: Git.Commit.Author(name: "Ash Furrow", email: "ash@ashfurrow.com", date: "2016-08-15T20:42:13Z"),
                committer: Git.Commit.Author(name: "Ash Furrow", email: "ash@ashfurrow.com", date: "2016-08-15T20:42:13Z"),
                message: "[Tests] Fixes typo, thanks @Gerst20051.",
                parents: Optional(["c330e8dfc6ae553a98fb9ffa6347f87d9f00f864"]),
                url: "https://api.github.com/repos/artsy/eidolon/commits/263d74a15e856f563f18864c459167c46c92cf48"
            ),
            Git.Commit(
                sha: "b71e4f62e248f2ca166582c4c9a6f15e14eaa15f",
                author: Git.Commit.Author(name: "Ash Furrow", email: "ash@ashfurrow.com", date: "2016-08-15T20:54:06Z"),
                committer: Git.Commit.Author(name: "Ash Furrow", email: "ash@ashfurrow.com", date: "2016-08-15T20:54:06Z"),
                message: "[Podfile] Adds comment for specific pod commit.", parents: Optional(["263d74a15e856f563f18864c459167c46c92cf48"]),
                url: "https://api.github.com/repos/artsy/eidolon/commits/b71e4f62e248f2ca166582c4c9a6f15e14eaa15f"
            ),
            Git.Commit(
                sha: "31b4eccb1bba8510485d468a0b73221eead2b0f0",
                author: Git.Commit.Author(name: "Ash Furrow", email: "ash@ashfurrow.com", date: "2016-08-16T23:23:51Z"),
                committer: Git.Commit.Author(name: "Ash Furrow", email: "ash@ashfurrow.com", date: "2016-08-16T23:23:51Z"),
                message: "[CI] Fix for intermittent CI failures.",
                parents: ["b71e4f62e248f2ca166582c4c9a6f15e14eaa15f"],
                url: "https://api.github.com/repos/artsy/eidolon/commits/31b4eccb1bba8510485d468a0b73221eead2b0f0"
            ),
            Git.Commit(
                sha: "db2af03f247bec4d12a3e743b4464a70501fac77",
                author: Git.Commit.Author(name: "Ash Furrow", email: "ash@ashfurrow.com", date: "2016-08-17T13:34:47Z"),
                committer: Git.Commit.Author(name: "Ash Furrow", email: "ash@ashfurrow.com", date: "2016-08-17T13:34:47Z"),
                message: "[Ruby] Adds version-specifier.",
                parents: ["31b4eccb1bba8510485d468a0b73221eead2b0f0"],
                url: "https://api.github.com/repos/artsy/eidolon/commits/db2af03f247bec4d12a3e743b4464a70501fac77"
            ),
            Git.Commit(
                sha: "57b041fbbbebd075f7fe186fb754cf7cce85519c",
                author: Git.Commit.Author(name: "Ash Furrow", email: "ash@ashfurrow.com", date: "2016-08-17T13:42:29Z"),
                committer: Git.Commit.Author(name: "Ash Furrow", email: "ash@ashfurrow.com", date: "2016-08-17T13:42:29Z"),
                message: "[CI] Split up failing test + switch to syncrhonous testing.",
                parents: ["db2af03f247bec4d12a3e743b4464a70501fac77"],
                url: "https://api.github.com/repos/artsy/eidolon/commits/57b041fbbbebd075f7fe186fb754cf7cce85519c"
            ),
            Git.Commit(
                sha: "851e911b4e8697a0f8e3b84c19df6cec30aead2a",
                author: Git.Commit.Author(name: "Ash Furrow", email: "ash@ashfurrow.com", date: "2016-08-17T13:48:43Z"),
                committer: Git.Commit.Author(name: "Ash Furrow", email: "ash@ashfurrow.com", date: "2016-08-17T13:58:30Z"),
                message: "[CI] Fixes pre-launching simulator UUID.",
                parents: ["57b041fbbbebd075f7fe186fb754cf7cce85519c"],
                url: "https://api.github.com/repos/artsy/eidolon/commits/851e911b4e8697a0f8e3b84c19df6cec30aead2a"
            ),
            Git.Commit(
                sha: "9963a5ff97b5dbd423df740c50e01a9dffd0a3ff",
                author: Git.Commit.Author(name: "Ash Furrow", email: "ash@ashfurrow.com", date: "2016-08-17T14:10:05Z"),
                committer: Git.Commit.Author(name: "Ash Furrow", email: "ash@ashfurrow.com", date: "2016-08-17T14:10:05Z"),
                message: "[CI] Fixes intermittently failing test comparing dates.",
                parents: ["851e911b4e8697a0f8e3b84c19df6cec30aead2a"],
                url: "https://api.github.com/repos/artsy/eidolon/commits/9963a5ff97b5dbd423df740c50e01a9dffd0a3ff"
            ),
            Git.Commit(
                sha: "1aa0360bc7a95d7878160ae91eea62324ac3252f",
                author: Git.Commit.Author(name: "Ash Furrow", email: "ash@ashfurrow.com", date: "2016-08-17T14:41:27Z"),
                committer: Git.Commit.Author(name: "Ash Furrow", email: "ash@ashfurrow.com", date: "2016-08-17T14:41:27Z"),
                message: "[Deps] Updates dependencies to latest Swift 2.x versions.",
                parents: ["9963a5ff97b5dbd423df740c50e01a9dffd0a3ff"],
                url: "https://api.github.com/repos/artsy/eidolon/commits/1aa0360bc7a95d7878160ae91eea62324ac3252f"
            ),
            Git.Commit(
                sha: "fb0688c603ddb48afe0edad336d3a7fac6f5e9f7",
                author: Git.Commit.Author(name: "Ash Furrow", email: "ash@ashfurrow.com", date: "2016-08-17T14:41:31Z"),
                committer: Git.Commit.Author(name: "Ash Furrow", email: "ash@ashfurrow.com", date: "2016-08-17T14:41:31Z"),
                message: "[CI] Fixes more intermittent tests.",
                parents: ["1aa0360bc7a95d7878160ae91eea62324ac3252f"],
                url: "https://api.github.com/repos/artsy/eidolon/commits/fb0688c603ddb48afe0edad336d3a7fac6f5e9f7"
            ),
            Git.Commit(
                sha: "c6eb849f100cbaa261680ee0d3dc819b91aa8af1",
                author: Git.Commit.Author(name: "Ash Furrow", email: "ash@ashfurrow.com", date: "2016-08-17T14:55:34Z"),
                committer: Git.Commit.Author(name: "Ash Furrow", email: "ash@ashfurrow.com", date: "2016-08-17T14:55:34Z"),
                message: "[CI] Removed duplicate simulator launch.",
                parents: Optional(["fb0688c603ddb48afe0edad336d3a7fac6f5e9f7"]),
                url: "https://api.github.com/repos/artsy/eidolon/commits/c6eb849f100cbaa261680ee0d3dc819b91aa8af1"
            ),
            Git.Commit(
                sha: "d769f276e066d79169a8bfa5795c8a4853f942f3",
                author: Git.Commit.Author(name: "Ash Furrow", email: "ash@ashfurrow.com", date: "2016-08-17T15:14:19Z"),
                committer: Git.Commit.Author(name: "Ash Furrow", email: "ash@ashfurrow.com", date: "2016-08-17T15:20:42Z"),
                message: "[Feedback] Adds clarifying comments as per feedback in #609.",
                parents: ["c6eb849f100cbaa261680ee0d3dc819b91aa8af1"],
                url: "https://api.github.com/repos/artsy/eidolon/commits/d769f276e066d79169a8bfa5795c8a4853f942f3"
            ),
        ])
    }
}
