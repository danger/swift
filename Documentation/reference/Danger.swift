import Darwin
import Darwin.C
import Foundation
import Logger
import OctoKit
import ShellOut
import SwiftOnoneSupport

public struct BitBucketServer: Decodable, Equatable {
    /// The pull request and repository metadata
    public let metadata: Danger.BitBucketServerMetadata

    /// The pull request metadata
    public let pullRequest: Danger.BitBucketServerPR

    /// The commits associated with the pull request
    public let commits: [Danger.BitBucketServerCommit]

    /// The comments on the pull request
    public let comments: [Danger.BitBucketServerComment]

    /// The activities such as OPENING, CLOSING, MERGING or UPDATING a pull request
    public let activities: [Danger.BitBucketServerActivity]
}

public struct BitBucketServerActivity: Decodable, Equatable {
    /// The activity's ID
    public let id: Int

    /// Date activity created as number of mili seconds since the unix epoch
    public let createdAt: Int

    /// The user that triggered the activity.
    public let user: Danger.BitBucketServerUser

    /// The action the activity describes (e.g. "COMMENTED").
    public let action: String

    /// In case the action was "COMMENTED" it will state the command specific action (e.g. "CREATED").
    public let commentAction: String?
}

public struct BitBucketServerComment: Decodable, Equatable {
    /// The comment's id
    public let id: Int

    /// Date comment created as number of mili seconds since the unix epoch
    public let createdAt: Int

    /// The comment's author
    public let user: Danger.BitBucketServerUser

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
    public let comment: Danger.BitBucketServerComment.CommentDetail?

    public struct CommentDetail: Decodable, Equatable {
        /// The comment's id
        public let id: Int

        /// The comment's version
        public let version: Int

        /// The comment content
        public let text: String

        /// The author of the comment
        public let author: Danger.BitBucketServerUser

        /// Date comment created as number of mili seconds since the unix epoch
        public let createdAt: Int

        /// Date comment updated as number of mili seconds since the unix epoch
        public let updatedAt: Int

        /// Replys to the comment
        public let comments: [Danger.BitBucketServerComment.CommentDetail]

        /// Properties associated with the comment
        public let properties: Danger.BitBucketServerComment.CommentDetail.InnerProperties

        /// Tasks associated with the comment
        public let tasks: [Danger.BitBucketServerComment.CommentDetail.BitBucketServerCommentTask]

        public struct BitBucketServerCommentTask: Decodable, Equatable {
            /// The tasks ID
            public let id: Int

            /// Date activity created as number of mili seconds since the unix epoch
            public let createdAt: Int

            /// The text of the task
            public let text: String

            /// The state of the task (e.g. "OPEN")
            public let state: String

            /// The author of the comment
            public let author: Danger.BitBucketServerUser
        }

        public struct InnerProperties: Decodable, Equatable {
            /// The ID of the repo
            public let repositoryId: Int

            /// Slugs of linkd Jira issues
            public let issues: [String]?
        }
    }
}

public struct BitBucketServerCommit: Decodable, Equatable {
    /// The SHA for the commit
    public let id: String

    /// The shortened SHA for the commit
    public let displayId: String

    /// The author of the commit, assumed to be the person who wrote the code.
    public let author: Danger.BitBucketServerUser

    /// The UNIX timestamp for when the commit was authored
    public let authorTimestamp: Int

    /// The author of the commit, assumed to be the person who commited/merged the code into a project.
    public let committer: Danger.BitBucketServerUser?

    /// When the commit was commited to the project
    public let committerTimestamp: Int?

    /// The commit's message
    public let message: String

    /// The commit's parents
    public let parents: [Danger.BitBucketServerCommit.BitBucketServerCommitParent]

    public struct BitBucketServerCommitParent: Decodable, Equatable {
        /// The SHA for the commit
        public let id: String

        /// The shortened SHA for the commit
        public let displayId: String
    }
}

public struct BitBucketServerMergeRef: Decodable, Equatable {
    /// The branch name
    public let id: String

    /// The human readable branch name
    public let displayId: String

    /// The SHA for the latest commit
    public let latestCommit: String

    /// Info of the associated repository
    public let repository: Danger.BitBucketServerRepo
}

public struct BitBucketServerMetadata: Decodable, Equatable {
    /// The PR's ID
    public var pullRequestID: String

    /// The complete repo slug including project slug.
    public var repoSlug: String
}

public struct BitBucketServerPR: Decodable, Equatable {
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
    public let fromRef: Danger.BitBucketServerMergeRef

    /// The repo Danger is running on
    public let toRef: Danger.BitBucketServerMergeRef

    /// Is the PR locked?
    public let isLocked: Bool

    /// The creator of the PR
    public let author: Danger.BitBucketServerPR.Participant

    /// People requested as reviewers
    public let reviewers: [Danger.BitBucketServerPR.Reviewer]

    /// People who have participated in the PR
    public let participants: [Danger.BitBucketServerPR.Participant]

    /// A user that is parecipating in the PR
    public struct Participant: Decodable, Equatable {
        /// The BitBucket Server User
        public let user: Danger.BitBucketServerUser
    }

    /// A user that reviewed the PR
    public struct Reviewer: Decodable, Equatable {
        /// The BitBucket Server User
        public let user: Danger.BitBucketServerUser

        /// The approval status
        public let approved: Bool

        /// The commit SHA for the latest commit that was reviewed
        public let lastReviewedCommit: String?
    }
}

public struct BitBucketServerProject: Decodable, Equatable {
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

public struct BitBucketServerRepo: Decodable, Equatable {
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
    public let project: Danger.BitBucketServerProject
}

public struct BitBucketServerUser: Decodable, Equatable {
    /// The unique user ID
    public let id: Int?

    /// The name of the user
    public let name: String

    /// The name to use when referencing the user
    public let displayName: String?

    /// The email for the user
    public let emailAddress: String

    /// Is the account active
    public let active: Bool?

    /// The user's slug for URLs
    public let slug: String?

    /// The type of a user, "NORMAL" being a typical user3
    public let type: String?
}

public struct DSL: Decodable {
    /// The root danger import
    public let danger: Danger.DangerDSL
}

public func Danger() -> Danger.DangerDSL

public struct DangerDSL: Decodable {
    public let git: Danger.Git

    public private(set) var github: Danger.GitHub!

    public let bitbucketServer: Danger.BitBucketServer!

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
    public func exec(_ command: String, arguments: [String] = default) -> String

    /// Gives you the ability to cheaply run a command and read the
    /// output without having to mess around too much, and exposes
    /// command errors in a pretty elegant way.
    ///
    /// - Parameter command: The first part of the command
    /// - Parameter arguments: An optional array of arguements to pass in extra
    /// - Returns: the stdout from the command
    public func spawn(_ command: String, arguments: [String] = default) throws -> String
}

/// A simple typealias for strings representing files
public typealias File = String

public enum FileType: String, Equatable {
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

extension FileType: CaseIterable {}

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

/// A platform agnostic reference to a git commit.
public struct GitCommit: Decodable, Equatable {
    /// The SHA for the commit.
    public let sha: String?

    /// Who wrote the commit.
    public let author: Danger.GitCommitAuthor

    /// Who shipped the code.
    public let committer: Danger.GitCommitAuthor

    /// The message for the commit.
    public let message: String

    /// SHAs for the commit's parents.
    public let parents: [String]?

    /// The URL for the commit.
    public let url: String
}

/// The author of a commit.
public struct GitCommitAuthor: Decodable, Equatable {
    /// The display name for the author.
    public let name: String

    /// The email for the author.
    public let email: String

    /// The ISO8601 date string for the commit.
    public let date: String
}

/// The GitHub metadata for your pull request.
public struct GitHub: Decodable {
    public let issue: Danger.GitHubIssue

    public let pullRequest: Danger.GitHubPR

    public let commits: [Danger.GitHubCommit]

    public let reviews: [Danger.GitHubReview]

    public let requestedReviewers: Danger.GitHubRequestedReviewers

    public internal(set) var api: OctoKit.Octokit!
}

/// A GitHub specific implementation of a git commit.
public struct GitHubCommit: Decodable, Equatable {
    /// The SHA for the commit.
    public let sha: String

    /// The raw commit metadata.
    public let commit: Danger.GitCommit

    /// The URL for the commit on GitHub.
    public let url: String

    /// The GitHub user who wrote the code.
    public let author: Danger.GitHubUser?

    /// The GitHub user who shipped the code.
    public let committer: Danger.GitHubUser?
}

public struct GitHubIssue: Decodable, Equatable {
    public enum IssueState: String, Decodable {
        case open

        case closed

        case locked
    }

    /// The id number of the issue
    public let id: Int

    /// The number of the issue.
    public let number: Int

    /// The title of the issue.
    public let title: String

    /// The user who created the issue.
    public let user: Danger.GitHubUser

    /// The state for the issue: open, closed, locked.
    public let state: Danger.GitHubIssue.IssueState

    /// A boolean indicating if the issue has been locked to contributors only.
    public let isLocked: Bool

    /// The markdown body message of the issue.
    public let body: String

    /// The comment number of comments for the issue.
    public let commentCount: Int

    /// The user who is assigned to the issue.
    public let assignee: Danger.GitHubUser?

    /// The users who are assigned to the issue.
    public let assignees: [Danger.GitHubUser]

    /// The milestone of this issue
    public let milestone: Danger.GitHubMilestone?

    /// The ISO8601 date string for when the issue was created.
    public let createdAt: Date

    /// The ISO8601 date string for when the issue was updated.
    public let updatedAt: Date

    /// The ISO8601 date string for when the issue was closed.
    public let closedAt: Date?

    /// The labels associated with this issue.
    public let labels: [Danger.GitHubIssueLabel]
}

public struct GitHubIssueLabel: Decodable, Equatable {
    /// The id number of this label.
    public let id: Int

    /// The URL that links to this label.
    public let url: String

    /// The name of the label.
    public let name: String

    /// The color associated with this label.
    public let color: String
}

/// Represents 'head' in PR
public struct GitHubMergeRef: Decodable, Equatable {
    /// The human display name for the merge reference, e.g. "artsy:master".
    public let label: String

    /// The reference point for the merge, e.g. "master"
    public let ref: String

    /// The reference point for the merge, e.g. "704dc55988c6996f69b6873c2424be7d1de67bbe"
    public let sha: String

    /// The user that owns the merge reference e.g. "artsy"
    public let user: Danger.GitHubUser

    /// The repo from which the reference comes from
    public let repo: Danger.GitHubRepo
}

public struct GitHubMilestone: Decodable, Equatable {
    public enum MilestoneState: String, Decodable {
        case open

        case closed

        case all
    }

    /// The id number of this milestone
    public let id: Int

    /// The number of this milestone
    public let number: Int

    /// The state of this milestone: open, closed, all
    public let state: Danger.GitHubMilestone.MilestoneState

    /// The title of this milestone
    public let title: String

    /// The description of this milestone.
    public let description: String

    /// The user who created this milestone.
    public let creator: Danger.GitHubUser

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

public struct GitHubPR: Decodable, Equatable {
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
    public let body: String

    /// The user who submitted the pull request.
    public let user: Danger.GitHubUser

    /// The user who is assigned to the pull request.
    public let assignee: Danger.GitHubUser?

    /// The users who are assigned to the pull request.
    public let assignees: [Danger.GitHubUser]?

    /// The ISO8601 date string for when the pull request was created.
    public let createdAt: Date

    /// The ISO8601 date string for when the pull request was updated.
    public let updatedAt: Date

    /// The ISO8601 date string for when the pull request was closed.
    public let closedAt: Date?

    /// The ISO8601 date string for when the pull request was merged.
    public let mergedAt: Date?

    /// The merge reference for the _other_ repo.
    public let head: Danger.GitHubMergeRef

    /// The merge reference for _this_ repo.
    public let base: Danger.GitHubMergeRef

    /// The state for the pull request: open, closed, locked, merged.
    public let state: Danger.GitHubPR.PullRequestState

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
    public let milestone: Danger.GitHubMilestone?

    /// The link back to this PR as user-facing
    public let htmlUrl: String
}

public struct GitHubRepo: Decodable, Equatable {
    /// Generic UUID.
    public let id: Int

    /// The name of the repo, e.g. "danger-swift".
    public let name: String

    /// The full name of the owner + repo, e.g. "Danger/danger-swift"
    public let fullName: String

    /// The owner of the repo.
    public let owner: Danger.GitHubUser

    /// A boolean stating whether the repo is publicly accessible.
    public let isPrivate: Bool

    /// A textual description of the repo.
    public let description: String?

    /// A boolean stating whether the repo is a fork.
    public let isFork: Bool

    /// The root web URL for the repo, e.g. https://github.com/artsy/emission
    public let htmlURL: String
}

/// Represents the payload for a PR's requested reviewers value.
public struct GitHubRequestedReviewers: Decodable, Equatable {
    /// The list of users of whom a review has been requested.
    public let users: [Danger.GitHubUser]

    /// The list of teams of whom a review has been requested.
    public let teams: [Danger.GitHubTeam]
}

public struct GitHubReview: Decodable, Equatable {
    public enum ReviewState: String, Decodable {
        case approved

        case requestedChanges

        case comment

        case pending

        case dismissed
    }

    /// The user who has completed the review or has been requested to review.
    public let user: Danger.GitHubUser

    /// The id for the review (if a review was made).
    public let id: Int?

    /// The body of the review (if a review was made).
    public let body: String?

    /// The commit ID the review was made on (if a review was made).
    public let commitId: String?

    /// The state of the review (if a review was made).
    public let state: Danger.GitHubReview.ReviewState?
}

/// A GitHub team.
public struct GitHubTeam: Decodable, Equatable {
    /// The UUID for the team.
    public let id: Int

    /// The team name
    public let name: String
}

/// A GitHub user account.
public struct GitHubUser: Decodable, Equatable {
    public enum UserType: String, Decodable {
        case user

        case organization
    }

    /// The UUID for the user organization.
    public let id: Int

    /// The handle for the user or organization.
    public let login: String

    /// The type of user: user or organization.
    public let userType: Danger.GitHubUser.UserType
}

/// Meta information for showing in the text info
public struct Meta: Encodable {}

public enum SpawnError: Error {
    case commandFailed(exitCode: Int32, stdout: String, stderr: String, task: Process)
}

/// The SwiftLint plugin has been embedded inside Danger, making
/// it usable out of the box.
public struct SwiftLint {
    /// This is the main entry point for linting Swift in PRs.
    ///
    /// When the swiftlintPath is not specified,
    /// it uses by default swift run swiftlint if the Package.swift contains swiftlint as dependency,
    /// otherwise calls directly the swiftlint command
    public static func lint(inline: Bool = default, directory: String? = default, configFile: String? = default, strict: Bool = default, lintAllFiles: Bool = default, swiftlintPath: String? = default) -> [Danger.SwiftLintViolation]
}

public struct SwiftLintViolation: Decodable {
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer throws an error if reading from the decoder fails, or
    /// if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    public init(from decoder: Decoder) throws

    public func toMarkdown() -> String
}

/// The result of a warn, message, or fail.
public struct Violation: Encodable {}

/// Adds an inline fail message to the Danger report
public func fail(message: String, file: String, line: Int)

/// Adds a warning message to the Danger report
///
/// - Parameter message: A markdown-ish
public func fail(_ message: String)

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

/// Adds an inline message to the Danger report
public func message(message: String, file: String, line: Int)

/// Adds a warning message to the Danger report
///
/// - Parameter message: A markdown-ish
public func message(_ message: String)

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
