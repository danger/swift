import Foundation
import OctoKit

// swiftlint:disable nesting
// swiftlint:disable file_length

/// The GitHub metadata for your pull request.
public struct GitHub: Decodable {
    enum CodingKeys: String, CodingKey {
        case issue
        case pullRequest = "pr"
        case commits
        case reviews
        case requestedReviewers = "requested_reviewers"
    }

    public let issue: Issue

    public let pullRequest: PullRequest

    public let commits: [Commit]

    public let reviews: [Review]

    public let requestedReviewers: RequestedReviewers

    public internal(set) var api: Octokit!
}

public extension GitHub {
    struct PullRequest: Decodable, Equatable {
        enum CodingKeys: String, CodingKey {
            case number
            case title
            case body
            case user
            case assignee
            case assignees
            case milestone
            case additions
            case deletions
            case state
            case head
            case base
            case isLocked = "locked"
            case isMerged = "merged"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case closedAt = "closed_at"
            case mergedAt = "merged_at"
            case commitCount = "commits"
            case commentCount = "comments"
            case reviewCommentCount = "review_comments"
            case changedFiles = "changed_files"
            case htmlUrl = "html_url"
            case draft
            case links = "_links"
        }

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
        public let user: User

        /// The user who is assigned to the pull request.
        public let assignee: User?

        /// The users who are assigned to the pull request.
        public let assignees: [User]?

        /// The ISO8601 date string for when the pull request was created.
        public let createdAt: Date

        /// The ISO8601 date string for when the pull request was updated.
        public let updatedAt: Date

        /// The ISO8601 date string for when the pull request was closed.
        public let closedAt: Date?

        /// The ISO8601 date string for when the pull request was merged.
        public let mergedAt: Date?

        /// The merge reference for the _other_ repo.
        public let head: MergeRef

        /// The merge reference for _this_ repo.
        public let base: MergeRef

        /// The state for the pull request: open, closed, locked, merged.
        public let state: PullRequestState

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
        public let milestone: Milestone?

        /// The link back to this PR as user-facing
        public let htmlUrl: String

        /// The draft state of the pull request
        public let draft: Bool?

        /// Possible link relations
        public let links: Link
    }
}

public extension GitHub.PullRequest {
    /// Pull Requests have possible link relations
    ///
    /// - See:
    ///   [Reference](https://docs.github.com/en/rest/reference/pulls#link-relations)
    struct Link: Decodable, Equatable {
        enum CodingKeys: String, CodingKey {
            case `self`
            case html
            case issue
            case comments
            case reviewComments = "review_comments"
            case reviewComment = "review_comment"
            case commits
            case statuses
        }

        public struct Relation: Decodable, Equatable, ExpressibleByStringLiteral {
            public let href: String

            public init(stringLiteral value: String) {
                href = value
            }
        }

        /// The API location of the Pull Request.
        public let `self`: Relation
        /// The HTML location of the Pull Request.
        public let html: Relation
        /// The API location of the Pull Request's Issue.
        public let issue: Relation
        /// The API location of the Pull Request's Issue comments.
        public let comments: Relation
        /// The API location of the Pull Request's Review comments.
        public let reviewComments: Relation
        /// The URL template to construct the API location for a Review comment in the Pull Request's repository.
        public let reviewComment: Relation
        /// The API location of the Pull Request's commits.
        public let commits: Relation
        /// The API location of the Pull Request's commit statuses, which are the statuses of its head branch.
        public let statuses: Relation
    }
}

public extension GitHub {
    /// A GitHub user account.
    struct User: Decodable, Equatable {
        enum CodingKeys: String, CodingKey {
            case id
            case login
            case userType = "type"
        }

        public enum UserType: String, Decodable {
            case user = "User"
            case organization = "Organization"
            case bot = "Bot"
            case mannequin = "Mannequin"
        }

        /// The UUID for the user organization.
        public let id: Int

        /// The handle for the user or organization.
        public let login: String

        /// The type of user: user, organization, or bot.
        public let userType: UserType
    }
}

public extension GitHub {
    /// A GitHub team.
    struct Team: Decodable, Equatable {
        /// The UUID for the team.
        public let id: Int

        /// The team name
        public let name: String
    }
}

public extension GitHub {
    /// Represents the payload for a PR's requested reviewers value.
    struct RequestedReviewers: Decodable, Equatable {
        /// The list of users of whom a review has been requested.
        public let users: [User]

        /// The list of teams of whom a review has been requested.
        public let teams: [Team]
    }
}

public extension GitHub {
    /// Represents 'head' in PR
    struct MergeRef: Decodable, Equatable {
        /// The human display name for the merge reference, e.g. "artsy:master".
        public let label: String

        /// The reference point for the merge, e.g. "master"
        public let ref: String

        /// The reference point for the merge, e.g. "704dc55988c6996f69b6873c2424be7d1de67bbe"
        public let sha: String

        /// The user that owns the merge reference e.g. "artsy"
        public let user: User

        /// The repo from which the reference comes from
        public let repo: Repo
    }
}

public extension GitHub {
    struct Repo: Decodable, Equatable {
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case owner
            case description
            case fullName = "full_name"
            case isPrivate = "private"
            case isFork = "fork"
            case htmlURL = "html_url"
        }

        /// Generic UUID.
        public let id: Int

        /// The name of the repo, e.g. "danger-swift".
        public let name: String

        /// The full name of the owner + repo, e.g. "Danger/danger-swift"
        public let fullName: String

        /// The owner of the repo.
        public let owner: User

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

public extension GitHub {
    struct Review: Decodable, Equatable {
        enum CodingKeys: String, CodingKey {
            case body
            case commitId = "commit_id"
            case id
            case state
            case submittedAt = "submitted_at"
            case user
        }

        public enum State: String, Decodable {
            case approved = "APPROVED"
            case requestedChanges = "CHANGES_REQUESTED"
            case comment = "COMMENTED"
            case pending = "PENDING"
            case dismissed = "DISMISSED"
        }

        /// The body of the review (if a review was made).
        public let body: String?

        /// The commit ID the review was made on (if a review was made).
        public let commitId: String?

        /// The id for the review (if a review was made).
        public let id: Int?

        /// The state of the review (if a review was made).
        public let state: State?

        /// The date when the review was submitted (if a review was made).
        public let submittedAt: Date?

        /// The user who has completed the review or has been requested to review.
        public let user: User
    }
}

public extension GitHub {
    /// A GitHub specific implementation of a git commit.
    struct Commit: Decodable, Equatable {
        enum CodingKeys: String, CodingKey {
            case sha
            case commit
            case url
            case author
            case committer
        }

        /// The SHA for the commit.
        public let sha: String

        /// The raw commit metadata.
        public let commit: CommitData

        /// The URL for the commit on GitHub.
        public let url: String

        /// The GitHub user who wrote the code.
        public let author: User?

        /// The GitHub user who shipped the code.
        public let committer: User?

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            sha = try container.decode(String.self, forKey: .sha)
            commit = try container.decode(CommitData.self, forKey: .commit)
            url = try container.decode(String.self, forKey: .url)
            author = (try? container.decodeIfPresent(User.self, forKey: .author)) ?? nil
            committer = (try? container.decodeIfPresent(User.self, forKey: .committer)) ?? nil
        }
    }
}

public extension GitHub.Commit {
    /// A GitHub specific implementation of a github commit.
    struct CommitData: Equatable, Decodable {
        /// The SHA for the commit.
        public let sha: String?

        /// Who wrote the commit.
        public let author: Git.Commit.Author

        /// Who shipped the code.
        public let committer: Git.Commit.Author

        /// The message for the commit.
        public let message: String

        /// SHAs for the commit's parents.
        public let parents: [String]?

        /// The URL for the commit.
        public let url: String

        public let verification: Verification
    }
}

public extension GitHub.Commit.CommitData {
    enum Verification: Equatable, Decodable {
        case verified(signature: String, payload: String)
        case unverified(UnverifiedReason)

        enum CodingKeys: String, CodingKey {
            case payload
            case reason
            case signature
            case verified
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let verified = try container.decode(Bool.self, forKey: .verified)

            if verified {
                let signature = try container.decode(String.self, forKey: .signature)
                let payload = try container.decode(String.self, forKey: .payload)
                self = .verified(signature: signature, payload: payload)
            } else {
                let reason = try container.decode(UnverifiedReason.self, forKey: .reason)
                self = .unverified(reason)
            }
        }
    }
}

public extension GitHub.Commit.CommitData.Verification {
    enum UnverifiedReason: String, Decodable {
        case expiredKey = "expired_key"
        case notSigningKey = "not_signing_key"
        case gpgVerifyError = "gpgverify_error"
        case gpgVerifyUnavailable = "gpgverify_unavailable"
        case unsigned
        case unknownSignatureType = "unknown_signature_type"
        case noUser = "no_user"
        case unverifiedEmail = "unverified_email"
        case badEmail = "bad_email"
        case unknownKey = "unknown_key"
        case malformedSignature = "malformed_signature"
        case invalid
    }
}

public extension GitHub {
    struct Issue: Decodable, Equatable {
        enum CodingKeys: String, CodingKey {
            case id
            case number
            case title
            case user
            case state
            case assignee
            case assignees
            case milestone
            case body
            case labels
            case commentCount = "comments"
            case isLocked = "locked"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case closedAt = "closed_at"
        }

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
        public let user: User

        /// The state for the issue: open, closed, locked.
        public let state: State

        /// A boolean indicating if the issue has been locked to contributors only.
        public let isLocked: Bool

        /// The markdown body message of the issue.
        public let body: String?

        /// The comment number of comments for the issue.
        public let commentCount: Int

        /// The user who is assigned to the issue.
        public let assignee: User?

        /// The users who are assigned to the issue.
        public let assignees: [User]

        /// The milestone of this issue
        public let milestone: Milestone?

        /// The ISO8601 date string for when the issue was created.
        public let createdAt: Date

        /// The ISO8601 date string for when the issue was updated.
        public let updatedAt: Date

        /// The ISO8601 date string for when the issue was closed.
        public let closedAt: Date?

        /// The labels associated with this issue.
        public let labels: [Label]
    }
}

public extension GitHub {
    struct Milestone: Decodable, Equatable {
        enum CodingKeys: String, CodingKey {
            case closedAt = "closed_at"
            case closedIssues = "closed_issues"
            case createdAt = "created_at"
            case creator
            case description
            case dueOn = "due_on"
            case id
            case number
            case openIssues = "open_issues"
            case state
            case title
            case updatedAt = "updated_at"
        }

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
        public let state: State

        /// The title of this milestone
        public let title: String

        /// The description of this milestone.
        public let description: String?

        /// The user who created this milestone.
        public let creator: User

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
