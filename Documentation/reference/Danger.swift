import DangerShellExecutor
import Darwin
import Darwin.C
import Foundation
import Logger
import OctoKit
import SwiftOnoneSupport

public struct BitBucketCloud: Decodable {
    /// The activities such as OPENING, CLOSING, MERGING or UPDATING a pull request
    public let activities: [Danger.BitBucketCloud.Activity]

    /// The comments on the pull request
    public let comments: [Danger.BitBucketCloud.Comment]

    /// The commits associated with the pull request
    public let commits: [Danger.BitBucketCloud.Commit]

    /// The pull request and repository metadata
    public let metadata: Danger.BitBucketMetadata

    /// The PR metadata
    public let pr: Danger.BitBucketCloud.PullRequest
}

extension BitBucketCloud {
    public struct PullRequest: Decodable {
        public enum State: String, Decodable {
            case declined

            case merged

            case open

            case suspended
        }

        public struct Participant: Decodable, Equatable {
            public enum Role: String, Decodable {
                case reviewer

                case participant
            }

            /// Did they approve of the PR?
            public let approved: Bool

            /// How did they contribute
            public let role: Danger.BitBucketCloud.PullRequest.Participant.Role

            /// The user who participated in this PR
            public let user: Danger.BitBucketCloud.User
        }

        /// The creator of the PR
        public let author: Danger.BitBucketCloud.User

        /// Date when PR was created
        public let createdOn: Date

        /// The text describing the PR
        public let description: String

        /// The PR's destination
        public let destination: Danger.BitBucketCloud.MergeRef

        /// PR's ID
        public let id: Int

        /// People who have participated in the PR
        public let participants: [Danger.BitBucketCloud.PullRequest.Participant]

        /// People requested as reviewers
        public let reviewers: [Danger.BitBucketCloud.User]

        /// The PR's source, The repo Danger is running on
        public let source: Danger.BitBucketCloud.MergeRef

        /// The pull request's current status.
        public let state: Danger.BitBucketCloud.PullRequest.State

        /// Title of the pull request
        public let title: String

        /// Date of last update
        public let updatedOn: Date
    }
}

extension BitBucketCloud {
    public struct MergeRef: Decodable {
        public var branchName: String { get }

        /// Hash of the last commit
        public var commitHash: String { get }

        public let repository: Danger.BitBucketCloud.Repo
    }
}

extension BitBucketCloud {
    public struct Repo: Decodable, Equatable {
        public let fullName: String

        public let name: String

        /// The uuid of the repository
        public let uuid: String
    }
}

extension BitBucketCloud {
    public struct User: Decodable, Equatable {
        /// The acount id of the user
        public let accountId: String

        /// The display name of user
        public let displayName: String

        /// The nick name of the user
        public let nickname: String

        /// The uuid of the user
        public let uuid: String
    }
}

extension BitBucketCloud {
    public struct Commit: Decodable, Equatable {
        public struct Author: Decodable, Equatable {}

        public struct Parent {}

        /// The author of the commit, assumed to be the person who wrote the code.
        public let author: Danger.BitBucketCloud.Commit.Author

        /// When the commit was commited to the project
        public let date: Date

        /// The SHA for the commit
        public let hash: String

        /// The commit's message
        public let message: String
    }
}

extension BitBucketCloud {
    public struct Comment: Decodable, Equatable {
        public struct Inline: Decodable, Equatable {
            public let from: Int

            public let to: Int

            public let path: String
        }

        /// Content of the comment
        public let content: Danger.BitBucketCloud.Content

        /// When the comment was created
        public let createdOn: Date

        /// Was the comment deleted?
        public let deleted: Bool

        public let id: Int

        public let inline: Danger.BitBucketCloud.Comment.Inline?

        public let type: String

        /// When the comment was updated
        public let updatedOn: Date

        /// The user that created the comment
        public let user: Danger.BitBucketCloud.User
    }
}

extension BitBucketCloud {
    public struct Content: Decodable, Equatable {
        public let html: String

        public let markup: String

        public let raw: String
    }
}

extension BitBucketCloud {
    public struct Activity: Decodable, Equatable {
        public let comment: Danger.BitBucketCloud.Comment?
    }
}

public struct BitBucketMetadata: Decodable, Equatable {
    /// The PR's ID
    public var pullRequestID: String

    /// The complete repo slug including project slug.
    public var repoSlug: String
}

public struct BitBucketServer: Decodable, Equatable {
    /// The pull request and repository metadata
    public let metadata: Danger.BitBucketMetadata

    /// The pull request metadata
    public let pullRequest: Danger.BitBucketServer.PullRequest

    /// The commits associated with the pull request
    public let commits: [Danger.BitBucketServer.Commit]

    /// The comments on the pull request
    public let comments: [Danger.BitBucketServer.Comment]

    /// The activities such as OPENING, CLOSING, MERGING or UPDATING a pull request
    public let activities: [Danger.BitBucketServer.Activity]
}

extension BitBucketServer {
    public struct Activity: Decodable, Equatable {
        /// The activity's ID
        public let id: Int

        /// Date activity created as number of mili seconds since the unix epoch
        public let createdAt: Int

        /// The user that triggered the activity.
        public let user: Danger.BitBucketServer.User

        /// The action the activity describes (e.g. "COMMENTED").
        public let action: String

        /// In case the action was "COMMENTED" it will state the command specific action (e.g. "CREATED").
        public let commentAction: String?
    }
}

extension BitBucketServer {
    public struct Comment: Decodable, Equatable {
        /// The comment's id
        public let id: Int

        /// Date comment created as number of mili seconds since the unix epoch
        public let createdAt: Int

        /// The comment's author
        public let user: Danger.BitBucketServer.User

        /// The action the user did (e.g. "COMMENTED")
        public let action: String

        /// The SHA to which the comment was created
        public let fromHash: String?

        /// The previous SHA to which the comment was created
        public let previousFromHash: String?

        /// The next SHA after the comment was created
        public let toHash: String?

        /// The SHA to which the comment was created
        public let previousToHash: String?

        /// Action the user did (e.g. "ADDED") if it is a new task
        public let commentAction: String?

        /// Detailed data of the comment
        public let comment: Danger.BitBucketServer.Comment.Detail?

        public struct Detail: Decodable, Equatable {
            /// The comment's id
            public let id: Int

            /// The comment's version
            public let version: Int

            /// The comment content
            public let text: String

            /// The author of the comment
            public let author: Danger.BitBucketServer.User

            /// Date comment created as number of mili seconds since the unix epoch
            public let createdAt: Int

            /// Date comment updated as number of mili seconds since the unix epoch
            public let updatedAt: Int

            /// Replys to the comment
            public let comments: [Danger.BitBucketServer.Comment.Detail]

            /// Properties associated with the comment
            public let properties: Danger.BitBucketServer.Comment.Detail.InnerProperties

            /// Tasks associated with the comment
            public let tasks: [Danger.BitBucketServer.Comment.Detail.Task]

            public struct Task: Decodable, Equatable {
                /// The tasks ID
                public let id: Int

                /// Date activity created as number of mili seconds since the unix epoch
                public let createdAt: Int

                /// The text of the task
                public let text: String

                /// The state of the task (e.g. "OPEN")
                public let state: String

                /// The author of the comment
                public let author: Danger.BitBucketServer.User
            }

            public struct InnerProperties: Decodable, Equatable {
                /// The ID of the repo
                public let repositoryId: Int

                /// Slugs of linkd Jira issues
                public let issues: [String]?
            }
        }
    }
}

extension BitBucketServer {
    public struct Commit: Decodable, Equatable {
        /// The SHA for the commit
        public let id: String

        /// The shortened SHA for the commit
        public let displayId: String

        /// The author of the commit, assumed to be the person who wrote the code.
        public let author: Danger.BitBucketServer.User

        /// The UNIX timestamp for when the commit was authored
        public let authorTimestamp: Int

        /// The author of the commit, assumed to be the person who commited/merged the code into a project.
        public let committer: Danger.BitBucketServer.User?

        /// When the commit was commited to the project
        public let committerTimestamp: Int?

        /// The commit's message
        public let message: String

        /// The commit's parents
        public let parents: [Danger.BitBucketServer.Commit.Parent]

        public struct Parent: Decodable, Equatable {
            /// The SHA for the commit
            public let id: String

            /// The shortened SHA for the commit
            public let displayId: String
        }
    }
}

extension BitBucketServer {
    public struct PullRequest: Decodable, Equatable {
        /// The PR's ID
        public let id: Int

        /// The API version
        public let version: Int

        /// Title of the pull request.
        public let title: String

        /// The description of the PR
        public let description: String?

        /// The pull request's current status.
        public let state: String

        /// Is PR open?
        public let open: Bool

        /// Is PR closed?
        public let closed: Bool

        /// Date PR created as number of mili seconds since the unix epoch
        public let createdAt: Int

        /// Date PR updated as number of mili seconds since the unix epoch
        public let updatedAt: Int?

        /// The PR submittor's reference
        public let fromRef: Danger.BitBucketServer.MergeRef

        /// The repo Danger is running on
        public let toRef: Danger.BitBucketServer.MergeRef

        /// Is the PR locked?
        public let isLocked: Bool

        /// The creator of the PR
        public let author: Danger.BitBucketServer.PullRequest.Participant

        /// People requested as reviewers
        public let reviewers: [Danger.BitBucketServer.PullRequest.Reviewer]

        /// People who have participated in the PR
        public let participants: [Danger.BitBucketServer.PullRequest.Participant]

        /// A user that is parecipating in the PR
        public struct Participant: Decodable, Equatable {
            /// The BitBucket Server User
            public let user: Danger.BitBucketServer.User
        }

        /// A user that reviewed the PR
        public struct Reviewer: Decodable, Equatable {
            /// The BitBucket Server User
            public let user: Danger.BitBucketServer.User

            /// The approval status
            public let approved: Bool

            /// The commit SHA for the latest commit that was reviewed
            public let lastReviewedCommit: String?
        }
    }
}

extension BitBucketServer {
    public struct MergeRef: Decodable, Equatable {
        /// The branch name
        public let id: String

        /// The human readable branch name
        public let displayId: String

        /// The SHA for the latest commit
        public let latestCommit: String

        /// Info of the associated repository
        public let repository: Danger.BitBucketServer.Repo
    }
}

extension BitBucketServer {
    public struct Repo: Decodable, Equatable {
        /// The repo name
        public let name: String?

        /// The slug for the repo
        public let slug: String

        /// The type of SCM tool, probably "git"
        public let scmId: String

        /// Is the repo public?
        public let isPublic: Bool

        /// Can someone fork thie repo?
        public let forkable: Bool

        /// An abtraction for grouping repos
        public let project: Danger.BitBucketServer.Project
    }
}

extension BitBucketServer {
    public struct Project: Decodable, Equatable {
        /// The project unique id
        public let id: Int

        /// The project's human readable project key
        public let key: String

        /// The name of the project
        public let name: String

        /// Is the project publicly available
        public let isPublic: Bool

        public let type: String
    }
}

extension BitBucketServer {
    public struct User: Decodable, Equatable {
        /// The unique user ID
        public let id: Int?

        /// The name of the user
        public let name: String

        /// The name to use when referencing the user
        public let displayName: String?

        /// The email for the user
        public let emailAddress: String?

        /// Is the account active
        public let active: Bool?

        /// The user's slug for URLs
        public let slug: String?

        /// The type of a user, "NORMAL" being a typical user3
        public let type: String?
    }
}

public struct DSL: Decodable {
    /// The root danger import
    public let danger: Danger.DangerDSL
}

public func Danger() -> Danger.DangerDSL

public struct DangerDSL: Decodable {
    public let git: Danger.Git

    public private(set) var github: Danger.GitHub! {
        get
    }

    public let bitbucketCloud: Danger.BitBucketCloud!

    public let bitbucketServer: Danger.BitBucketServer!

    public let gitLab: Danger.GitLab!

    public let utils: Danger.DangerUtils

    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer throws an error if reading from the decoder fails, or
    /// if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    public init(from decoder: Decoder) throws
}

extension DangerDSL {
    /// Fails on the Danger report
    public var fails: [Danger.Violation] { get }

    /// Warnings on the Danger report
    public var warnings: [Danger.Violation] { get }

    /// Messages on the Danger report
    public var messages: [Danger.Violation] { get }

    /// Markdowns on the Danger report
    public var markdowns: [Danger.Violation] { get }

    /// Adds a warning message to the Danger report
    ///
    /// - Parameter message: A markdown-ish
    public func warn(_ message: String)

    /// Adds an inline warning message to the Danger report
    public func warn(message: String, file: String, line: Int)

    /// Adds a warning message to the Danger report
    ///
    /// - Parameter message: A markdown-ish
    public func fail(_ message: String)

    /// Adds an inline fail message to the Danger report
    public func fail(message: String, file: String, line: Int)

    /// Adds a warning message to the Danger report
    ///
    /// - Parameter message: A markdown-ish
    public func message(_ message: String)

    /// Adds an inline message to the Danger report
    public func message(message: String, file: String, line: Int)

    /// Adds a warning message to the Danger report
    ///
    /// - Parameter message: A markdown-ish
    public func markdown(_ message: String)

    /// Adds an inline message to the Danger report
    public func markdown(message: String, file: String, line: Int)

    /// Adds an inline suggestion to the Danger report (sends a normal message if suggestions are not supported)
    public func suggestion(code: String, file: String, line: Int)
}

/// Utility functions that make Dangerfiles easier to write
public struct DangerUtils {
    /// Let's you go from a file path to the contents of the file
    /// with less hassle.
    ///
    /// It specifically assumes golden path code so Dangerfiles
    /// don't have to include error handlings - an error will
    /// exit evaluation entirely as it should only happen at dev-time.
    ///
    /// - Parameter file: the file reference from git.modified/creasted/deleted etc
    /// - Returns: the file contents, or bails
    public func readFile(_ file: File) -> String

    /// Returns the line number of the lines that contain a specific string in a file
    ///
    /// - Parameter string: The string you want to search
    /// - Parameter file: The file path of the file where you want to search the string
    /// - Returns: the line number of the lines where the passed string is contained
    public func lines(for string: String, inFile file: File) -> [Int]

    /// Gives you the ability to cheaply run a command and read the
    /// output without having to mess around
    ///
    /// It generally assumes that the command will pass, as you only get
    /// a string of the STDOUT. If you think your command could/should fail
    /// then you want to use `spawn` instead.
    ///
    /// - Parameter command: The first part of the command
    /// - Parameter arguments: An optional array of arguements to pass in extra
    /// - Returns: the stdout from the command
    public func exec(_ command: String, arguments: [String] = []) -> String

    /// Gives you the ability to cheaply run a command and read the
    /// output without having to mess around too much, and exposes
    /// command errors in a pretty elegant way.
    ///
    /// - Parameter command: The first part of the command
    /// - Parameter arguments: An optional array of arguements to pass in extra
    /// - Returns: the stdout from the command
    public func spawn(_ command: String, arguments: [String] = []) throws -> String
}

/// A simple typealias for strings representing files
public typealias File = String

public enum FileType: String, Equatable, CaseIterable {
    case h

    case json

    case m

    case markdown

    case mm

    case pbxproj

    case plist

    case storyboard

    case swift

    case xcscheme

    case yaml

    case yml
}

extension FileType {
    public var `extension`: String { get }
}

/// The git specific metadata for a pull request.
public struct Git: Decodable, Equatable {
    /// Modified filepaths relative to the git root.
    public let modifiedFiles: [File]

    /// Newly created filepaths relative to the git root.
    public let createdFiles: [File]

    /// Removed filepaths relative to the git root.
    public let deletedFiles: [File]
}

extension Git {
    /// A platform agnostic reference to a git commit.
    public struct Commit: Decodable, Equatable {
        /// The author of a commit.
        public struct Author: Decodable, Equatable {
            /// The display name for the author.
            public let name: String

            /// The email for the author.
            public let email: String

            /// The ISO8601 date string for the commit.
            public let date: String
        }

        /// The SHA for the commit.
        public let sha: String?

        /// Who wrote the commit.
        public let author: Danger.Git.Commit.Author

        /// Who shipped the code.
        public let committer: Danger.Git.Commit.Author

        /// The message for the commit.
        public let message: String

        /// SHAs for the commit's parents.
        public let parents: [String]?

        /// The URL for the commit.
        public let url: String
    }
}

/// The GitHub metadata for your pull request.
public struct GitHub: Decodable {
    public let issue: Danger.GitHub.Issue

    public let pullRequest: Danger.GitHub.PullRequest

    public let commits: [Danger.GitHub.Commit]

    public let reviews: [Danger.GitHub.Review]

    public let requestedReviewers: Danger.GitHub.RequestedReviewers

    public internal(set) var api: OctoKit.Octokit! {
        get
    }
}

extension GitHub {
    public struct PullRequest: Decodable, Equatable {
        public enum PullRequestState: String, Decodable {
            case open

            case closed

            case merged

            case locked
        }

        /// The number of the pull request.
        public let number: Int

        /// The title of the pull request.
        public let title: String

        /// The markdown body message of the pull request.
        public let body: String?

        /// The user who submitted the pull request.
        public let user: Danger.GitHub.User

        /// The user who is assigned to the pull request.
        public let assignee: Danger.GitHub.User?

        /// The users who are assigned to the pull request.
        public let assignees: [Danger.GitHub.User]?

        /// The ISO8601 date string for when the pull request was created.
        public let createdAt: Date

        /// The ISO8601 date string for when the pull request was updated.
        public let updatedAt: Date

        /// The ISO8601 date string for when the pull request was closed.
        public let closedAt: Date?

        /// The ISO8601 date string for when the pull request was merged.
        public let mergedAt: Date?

        /// The merge reference for the _other_ repo.
        public let head: Danger.GitHub.MergeRef

        /// The merge reference for _this_ repo.
        public let base: Danger.GitHub.MergeRef

        /// The state for the pull request: open, closed, locked, merged.
        public let state: Danger.GitHub.PullRequest.PullRequestState

        /// A boolean indicating if the pull request has been locked to contributors only.
        public let isLocked: Bool

        /// A boolean indicating if the pull request has been merged.
        public let isMerged: Bool?

        /// The number of commits in the pull request.
        public let commitCount: Int?

        /// The number of comments in the pull request.
        public let commentCount: Int?

        /// The number of review-specific comments in the pull request.
        public let reviewCommentCount: Int?

        /// The number of added lines in the pull request.
        public let additions: Int?

        /// The number of deleted lines in the pull request.
        public let deletions: Int?

        /// The number of files changed in the pull request.
        public let changedFiles: Int?

        /// The milestone of the pull request
        public let milestone: Danger.GitHub.Milestone?

        /// The link back to this PR as user-facing
        public let htmlUrl: String
    }
}

extension GitHub {
    /// A GitHub user account.
    public struct User: Decodable, Equatable {
        public enum UserType: String, Decodable {
            case user

            case organization

            case bot
        }

        /// The UUID for the user organization.
        public let id: Int

        /// The handle for the user or organization.
        public let login: String

        /// The type of user: user, organization, or bot.
        public let userType: Danger.GitHub.User.UserType
    }
}

extension GitHub {
    /// A GitHub team.
    public struct Team: Decodable, Equatable {
        /// The UUID for the team.
        public let id: Int

        /// The team name
        public let name: String
    }
}

extension GitHub {
    /// Represents the payload for a PR's requested reviewers value.
    public struct RequestedReviewers: Decodable, Equatable {
        /// The list of users of whom a review has been requested.
        public let users: [Danger.GitHub.User]

        /// The list of teams of whom a review has been requested.
        public let teams: [Danger.GitHub.Team]
    }
}

extension GitHub {
    /// Represents 'head' in PR
    public struct MergeRef: Decodable, Equatable {
        /// The human display name for the merge reference, e.g. "artsy:master".
        public let label: String

        /// The reference point for the merge, e.g. "master"
        public let ref: String

        /// The reference point for the merge, e.g. "704dc55988c6996f69b6873c2424be7d1de67bbe"
        public let sha: String

        /// The user that owns the merge reference e.g. "artsy"
        public let user: Danger.GitHub.User

        /// The repo from which the reference comes from
        public let repo: Danger.GitHub.Repo
    }
}

extension GitHub {
    public struct Repo: Decodable, Equatable {
        /// Generic UUID.
        public let id: Int

        /// The name of the repo, e.g. "danger-swift".
        public let name: String

        /// The full name of the owner + repo, e.g. "Danger/danger-swift"
        public let fullName: String

        /// The owner of the repo.
        public let owner: Danger.GitHub.User

        /// A boolean stating whether the repo is publicly accessible.
        public let isPrivate: Bool

        /// A textual description of the repo.
        public let description: String?

        /// A boolean stating whether the repo is a fork.
        public let isFork: Bool

        /// The root web URL for the repo, e.g. https://github.com/artsy/emission
        public let htmlURL: String
    }
}

extension GitHub {
    public struct Review: Decodable, Equatable {
        public enum State: String, Decodable {
            case approved

            case requestedChanges

            case comment

            case pending

            case dismissed
        }

        /// The user who has completed the review or has been requested to review.
        public let user: Danger.GitHub.User

        /// The id for the review (if a review was made).
        public let id: Int?

        /// The body of the review (if a review was made).
        public let body: String?

        /// The commit ID the review was made on (if a review was made).
        public let commitId: String?

        /// The state of the review (if a review was made).
        public let state: Danger.GitHub.Review.State?
    }
}

extension GitHub {
    /// A GitHub specific implementation of a git commit.
    public struct Commit: Decodable, Equatable {
        /// The SHA for the commit.
        public let sha: String

        /// The raw commit metadata.
        public let commit: Danger.Git.Commit

        /// The URL for the commit on GitHub.
        public let url: String

        /// The GitHub user who wrote the code.
        public let author: Danger.GitHub.User?

        /// The GitHub user who shipped the code.
        public let committer: Danger.GitHub.User?

        /// Creates a new instance by decoding from the given decoder.
        ///
        /// This initializer throws an error if reading from the decoder fails, or
        /// if the data read is corrupted or otherwise invalid.
        ///
        /// - Parameter decoder: The decoder to read data from.
        public init(from decoder: Decoder) throws
    }
}

extension GitHub {
    public struct Issue: Decodable, Equatable {
        public enum State: String, Decodable {
            case open

            case closed

            case locked
        }

        public struct Label: Decodable, Equatable {
            /// The id number of this label.
            public let id: Int

            /// The URL that links to this label.
            public let url: String

            /// The name of the label.
            public let name: String

            /// The color associated with this label.
            public let color: String
        }

        /// The id number of the issue
        public let id: Int

        /// The number of the issue.
        public let number: Int

        /// The title of the issue.
        public let title: String

        /// The user who created the issue.
        public let user: Danger.GitHub.User

        /// The state for the issue: open, closed, locked.
        public let state: Danger.GitHub.Issue.State

        /// A boolean indicating if the issue has been locked to contributors only.
        public let isLocked: Bool

        /// The markdown body message of the issue.
        public let body: String?

        /// The comment number of comments for the issue.
        public let commentCount: Int

        /// The user who is assigned to the issue.
        public let assignee: Danger.GitHub.User?

        /// The users who are assigned to the issue.
        public let assignees: [Danger.GitHub.User]

        /// The milestone of this issue
        public let milestone: Danger.GitHub.Milestone?

        /// The ISO8601 date string for when the issue was created.
        public let createdAt: Date

        /// The ISO8601 date string for when the issue was updated.
        public let updatedAt: Date

        /// The ISO8601 date string for when the issue was closed.
        public let closedAt: Date?

        /// The labels associated with this issue.
        public let labels: [Danger.GitHub.Issue.Label]
    }
}

extension GitHub {
    public struct Milestone: Decodable, Equatable {
        public enum State: String, Decodable {
            case open

            case closed

            case all
        }

        /// The id number of this milestone
        public let id: Int

        /// The number of this milestone
        public let number: Int

        /// The state of this milestone: open, closed, all
        public let state: Danger.GitHub.Milestone.State

        /// The title of this milestone
        public let title: String

        /// The description of this milestone.
        public let description: String?

        /// The user who created this milestone.
        public let creator: Danger.GitHub.User

        /// The number of open issues in this milestone
        public let openIssues: Int

        /// The number of closed issues in this milestone
        public let closedIssues: Int

        /// The ISO8601 date string for when this milestone was created.
        public let createdAt: Date

        /// The ISO8601 date string for when this milestone was updated.
        public let updatedAt: Date

        /// The ISO8601 date string for when this milestone was closed.
        public let closedAt: Date?

        /// The ISO8601 date string for the due of this milestone.
        public let dueOn: Date?
    }
}

public struct GitLab: Decodable {
    public enum CodingKeys: String, CodingKey {
        case mergeRequest

        case metadata
    }

    public let mergeRequest: Danger.GitLab.MergeRequest

    public let metadata: Danger.GitLab.Metadata
}

extension GitLab {
    public struct Metadata: Decodable, Equatable {
        public let pullRequestID: String

        public let repoSlug: String
    }
}

extension GitLab {
    public struct MergeRequest: Decodable, Equatable {
        public enum State: String, Decodable {
            case closed

            case locked

            case merged

            case open
        }

        public struct Milestone: Decodable, Equatable {
            public enum CodingKeys: String, CodingKey {
                case createdAt

                case description

                case dueDate

                case id

                case iid

                case projectId

                case startDate

                case state

                case title

                case updatedAt

                case webUrl
            }

            public enum State: String, Decodable {
                case active

                case closed
            }

            public let createdAt: Date

            public let description: String

            public let dueDate: Date

            public let id: Int

            public let iid: Int

            public let projectId: Int

            public let startDate: Date

            public let state: Danger.GitLab.MergeRequest.Milestone.State

            public let title: String

            public let updatedAt: Date

            public let webUrl: String
        }

        public struct TimeStats: Decodable, Equatable {
            public enum CodingKeys: String, CodingKey {
                case humanTimeEstimate

                case humanTimeSpent

                case timeEstimate

                case totalTimeSpent
            }

            public let humanTimeEstimate: Int?

            public let humanTimeSpent: Int?

            public let timeEstimate: Int

            public let totalTimeSpent: Int
        }

        public struct DiffRefs: Decodable, Equatable {}

        public struct Pipeline: Decodable, Equatable {
            public enum Status: String, Decodable {
                case canceled

                case failed

                case pending

                case running

                case skipped

                case success
            }

            public enum CodingKeys: String, CodingKey {
                case id

                case ref

                case sha

                case status

                case webUrl
            }

            public let id: Int

            public let ref: String

            public let sha: String

            public let status: Danger.GitLab.MergeRequest.Pipeline.Status

            public let webUrl: String
        }

        public enum CodingKeys: String, CodingKey {
            case allowCollaboration

            case allowMaintainerToPush

            case approvalsBeforeMerge

            case assignee

            case author

            case changesCount

            case closedAt

            case closedBy

            case description

            case diffRefs

            case downvotes

            case firstDeployedToProductionAt

            case forceRemoveSourceBranch

            case id

            case iid

            case latestBuildStartedAt

            case latestBuildFinishedAt

            case labels

            case mergeCommitSha

            case mergedAt

            case mergedBy

            case mergeOnPipelineSuccess

            case milestone

            case pipeline

            case projectId

            case sha

            case shouldRemoveSourceBranch

            case sourceBranch

            case sourceProjectId

            case state

            case subscribed

            case targetBranch

            case targetProjectId

            case timeStats

            case title

            case upvotes

            case userMergeData

            case userNotesCount

            case webUrl

            case workInProgress
        }

        public let allowCollaboration: Bool

        public let allowMaintainerToPush: Bool

        public let approvalsBeforeMerge: Int?

        public let assignee: Danger.GitLab.User?

        public let author: Danger.GitLab.User

        public let changesCount: String

        public let closedAt: Date?

        public let closedBy: Danger.GitLab.User?

        public let description: String

        public let diffRefs: Danger.GitLab.MergeRequest.DiffRefs

        public let downvotes: Int

        public let firstDeployedToProductionAt: Date?

        public let forceRemoveSourceBranch: Bool

        public let id: Int

        public let iid: Int

        public let latestBuildFinishedAt: Date?

        public let latestBuildStartedAt: Date?

        public let labels: [String]

        public let mergeCommitSha: String?

        public let mergedAt: Date?

        public let mergedBy: Danger.GitLab.User?

        public let mergeOnPipelineSuccess: Bool

        public let milestone: Danger.GitLab.MergeRequest.Milestone?

        public let pipeline: Danger.GitLab.MergeRequest.Pipeline?

        public let projectId: Int

        public let sha: String

        public let shouldRemoveSourceBranch: Bool?

        public let sourceBranch: String

        public let sourceProjectId: Int

        public let state: Danger.GitLab.MergeRequest.State

        public let subscribed: Bool

        public let targetBranch: String

        public let targetProjectId: Int

        public let timeStats: Danger.GitLab.MergeRequest.TimeStats

        public let title: String

        public let upvotes: Int

        public let userNotesCount: Int

        public let webUrl: String

        public let workInProgress: Bool

        public var userCanMerge: Bool { get }
    }
}

extension GitLab {
    public struct User: Decodable, Equatable {
        public enum CodingKeys: String, CodingKey {
            case avatarUrl

            case id

            case name

            case state

            case username

            case webUrl
        }

        public enum State: String, Decodable {
            case active

            case blocked
        }

        public let avatarUrl: String?

        public let id: Int

        public let name: String

        public let state: Danger.GitLab.User.State

        public let username: String

        public let webUrl: String
    }
}

/// Meta information for showing in the text info
public struct Meta: Encodable {}

/// The SwiftLint plugin has been embedded inside Danger, making
/// it usable out of the box.
public struct SwiftLint {
    /// This is the main entry point for linting Swift in PRs.
    ///
    /// When the swiftlintPath is not specified,
    /// it uses by default swift run swiftlint if the Package.swift contains swiftlint as dependency,
    /// otherwise calls directly the swiftlint command
    public static func lint(inline: Bool = false, directory: String? = nil, configFile: String? = nil, strict: Bool = false, lintAllFiles: Bool = false, swiftlintPath: String? = nil) -> [Danger.SwiftLintViolation]
}

public struct SwiftLintViolation: Decodable {
    public func toMarkdown() -> String
}

/// The result of a warn, message, or fail.
public struct Violation: Encodable {}

/// Adds a warning message to the Danger report
///
/// - Parameter message: A markdown-ish
public func fail(_ message: String)

/// Adds an inline fail message to the Danger report
public func fail(message: String, file: String, line: Int)

/// Fails on the Danger report
public var fails: [Danger.Violation] { get }

/// Adds a warning message to the Danger report
///
/// - Parameter message: A markdown-ish
public func markdown(_ message: String)

/// Adds an inline message to the Danger report
public func markdown(message: String, file: String, line: Int)

/// Markdowns on the Danger report
public var markdowns: [Danger.Violation] { get }

/// Adds a warning message to the Danger report
///
/// - Parameter message: A markdown-ish
public func message(_ message: String)

/// Adds an inline message to the Danger report
public func message(message: String, file: String, line: Int)

/// Messages on the Danger report
public var messages: [Danger.Violation] { get }

/// Adds an inline suggestion to the Danger report (sends a normal message if suggestions are not supported)
public func suggestion(code: String, file: String, line: Int)

/// Adds a warning message to the Danger report
///
/// - Parameter message: A markdown-ish
public func warn(_ message: String)

/// Adds an inline warning message to the Danger report
public func warn(message: String, file: String, line: Int)

/// Warnings on the Danger report
public var warnings: [Danger.Violation] { get }

extension DateFormatter {
    public static var defaultDateFormatter: DateFormatter { get }
}

extension String {
    public var fileType: Danger.FileType? { get }

    public var name: String { get }
}

/// Fails on the Danger report
public let fails: [Danger.Violation] { get }

/// Warnings on the Danger report
public let warnings: [Danger.Violation] { get }

/// Messages on the Danger report
public let messages: [Danger.Violation] { get }

/// Markdowns on the Danger report
public let markdowns: [Danger.Violation] { get }
