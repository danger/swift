import Foundation

// http://benscheirman.com/2017/06/ultimate-guide-to-json-parsing-with-swift-4/

// MARK: - GitHub

/// The GitHub metadata for your pull request.
public struct GitHub: Decodable {

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case issue = "issue"
        case pullRequest = "pr"
        case commits = "commits"
        case reviews = "reviews"
        case requestedReviewers = "requested_reviewers"
    }

    // MARK: - Properties

    public let issue: GitHubIssue

    public let pullRequest: GitHubPR

    public let commits: [GitHubCommit]

    public let reviews: [GitHubReview]

    public let requestedReviewers: GitHubRequestedReviewers

}

// MARK: - GitHubPR

public struct GitHubPR: Decodable {

    // MARK: - CodingKeys

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

    }

    // MARK: - PullRequestState

    public enum PullRequestState: String, Decodable {
        case open
        case closed
        case merged
        case locked
    }

    // MARK: - Properties

    /// The number of the pull request.
    public let number: Int

    /// The title of the pull request.
    public let title: String

    /// The markdown body message of the pull request.
    public let body: String

    /// The user who submitted the pull request.
    public let user: GitHubUser

    /// The user who is assigned to the pull request.
    public let assignee: GitHubUser?

    /// The users who are assigned to the pull request.
    public let assignees: [GitHubUser]

    /// The ISO8601 date string for when the pull request was created.
    public let createdAt: Date

    /// The ISO8601 date string for when the pull request was updated.
    public let updatedAt: Date

    /// The ISO8601 date string for when the pull request was closed.
    public let closedAt: Date?

    /// The ISO8601 date string for when the pull request was merged.
    public let mergedAt: Date?

    /// The merge reference for the _other_ repo.
    public let head: GitHubMergeRef

    /// The merge reference for _this_ repo.
    public let base: GitHubMergeRef

    /// The state for the pull request: open, closed, locked, merged.
    public let state: PullRequestState

    /// A boolean indicating if the pull request has been locked to contributors only.
    public let isLocked: Bool

    /// A boolean indicating if the pull request has been merged.
    public let isMerged: Bool

    /// The number of commits in the pull request.
    public let commitCount: Int

    /// The number of comments in the pull request.
    public let commentCount: Int

    /// The number of review-specific comments in the pull request.
    public let reviewCommentCount: Int

    /// The number of added lines in the pull request.
    public let additions: Int

    /// The number of deleted lines in the pull request.
    public let deletions: Int

    /// The number of files changed in the pull request.
    public let changedFiles: Int

    /// The milestone of the pull request
    public let milestone: GitHubMilestone?

}

// MARK: - GitHubUser

/// A GitHub user account.
public struct GitHubUser: Decodable {

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case userType = "type"
    }

    // MARK: - UserType

    public enum UserType: String, Decodable {
        case user = "User"
        case organization = "Organization"
    }

    // MARK: - Properties

    /// The UUID for the user organization.
    public let id: Int

    /// The handle for the user or organization.
    public let login: String

    /// The type of user: user or organization.
    public let userType: UserType

}

// MARK: - GitHubTeam

/// A GitHub team.
public struct GitHubTeam: Decodable {

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case id
        case name
    }

    // MARK: - Properties

    /// The UUID for the team.
    public let id: Int

    /// The team name
    public let name: String
}

// MARK: - GitHubRequestedReviewers

/// Represents the payload for a PR's requested reviewers value.
public struct GitHubRequestedReviewers: Decodable {

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case users
        case teams
    }

    // MARK: - Properties

    /// The list of users of whom a review has been requested.
    public let users: [GitHubUser]

    /// The list of teams of whom a review has been requested.
    public let teams: [GitHubTeam]
}

// MARK: - GitHubMergeRef

public struct GitHubMergeRef: Decodable {

    // MARK: - Properties

    /// The human display name for the merge reference, e.g. "artsy:master".
    public let label: String

    /// The reference point for the merge, e.g. "master"
    public let ref: String

    /// The reference point for the merge, e.g. "704dc55988c6996f69b6873c2424be7d1de67bbe"
    public let sha: String

    /// The user that owns the merge reference e.g. "artsy"
    public let user: GitHubUser

    /// The repo from which the reference comes from
    public let repo: GitHubRepo

}

// MARK: - GitHubRepo

public struct GitHubRepo: Decodable {

    // MARK: - CodingKeys

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

    // MARK: - Properties

    /// Generic UUID.
    public let id: Int

    /// The name of the repo, e.g. "danger-swift".
    public let name: String

    /// The full name of the owner + repo, e.g. "Danger/danger-swift"
    public let fullName: String

    /// The owner of the repo.
    public let owner: GitHubUser

    /// A boolean stating whether the repo is publicly accessible.
    public let isPrivate: Bool

    /// A textual description of the repo.
    public let description: String

    /// A boolean stating whether the repo is a fork.
    public let isFork: Bool

    /// The root web URL for the repo, e.g. https://github.com/artsy/emission
    public let htmlURL: String

}

// MARK: - GitHubReview

public struct GitHubReview: Decodable {

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case user
        case id
        case body
        case state
        case commitId = "commit_id"
    }

    // MARK: - ReviewState

    public enum ReviewState: String, Decodable {
        case approved = "APPROVED"
        case requestedChanges = "CHANGES_REQUESTED"
        case comment = "COMMENTED"
        case pending = "PENDING"
        case dismissed = "DISMISSED"
    }

    /// The user who has completed the review or has been requested to review.
    public let user: GitHubUser

    /// The id for the review (if a review was made).
    public let id: Int?

    /// The body of the review (if a review was made).
    public let body: String?

    /// The commit ID the review was made on (if a review was made).
    public let commitId: String?

    /// The state of the review (if a review was made).
    public let state: ReviewState?

}

// MARK: - GitHubCommit

/// A GitHub specific implementation of a git commit.
public struct GitHubCommit: Decodable {

    // MARK: - Properties

    /// The SHA for the commit.
    public let sha: String

    /// The raw commit metadata.
    public let commit: GitCommit

    /// The URL for the commit on GitHub.
    public let url: String

    /// The GitHub user who wrote the code.
    public let author: GitHubUser

    /// The GitHub user who shipped the code.
    public let committer: GitHubUser

}

// MARK: - GitHubIssue

public struct GitHubIssue: Decodable {

    // MARK: - CodingKeys

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

    // MARK: - IssueState

    public enum IssueState: String, Decodable {
        case open
        case closed
        case locked
    }

    // MARK: - Properties

    /// The id number of the issue
    public let id: Int

    /// The number of the issue.
    public let number: Int

    /// The title of the issue.
    public let title: String

    /// The user who created the issue.
    public let user: GitHubUser

    /// The state for the issue: open, closed, locked.
    public let state: IssueState

    /// A boolean indicating if the issue has been locked to contributors only.
    public let isLocked: Bool

    /// The markdown body message of the issue.
    public let body: String

    /// The comment number of comments for the issue.
    public let commentCount: Int

    /// The user who is assigned to the issue.
    public let assignee: GitHubUser?

    /// The users who are assigned to the issue.
    public let assignees: [GitHubUser]

    /// The milestone of this issue
    public let milestone: GitHubMilestone?

    /// The ISO8601 date string for when the issue was created.
    public let createdAt: Date

    /// The ISO8601 date string for when the issue was updated.
    public let updatedAt: Date

    /// The ISO8601 date string for when the issue was closed.
    public let closedAt: Date?

    /// The labels associated with this issue.
    public let labels: [GitHubIssueLabel]

}

// MARK: - GitHubIssueLabel

public struct GitHubIssueLabel: Decodable {

    // MARK: - Properties

    /// The id number of this label.
    public let id: Int

    /// The URL that links to this label.
    public let url: String

    /// The name of the label.
    public let name: String

    /// The color associated with this label.
    public let color: String

}

// MARK: - GitHubMilestone

public struct GitHubMilestone: Decodable {

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case closedAt = "closed_at"
        case closedIssues = "closed_issues"
        case createdAt = "created_at"
        case creator = "creator"
        case description = "description"
        case dueOn = "due_on"
        case id = "id"
        case number = "number"
        case openIssues = "open_issues"
        case state = "state"
        case title = "title"
        case updatedAt = "updated_at"
    }

    // MARK: - MilestoneState

    public enum MilestoneState: String, Decodable {
        case open
        case closed
        case all
    }

    // MARK: - Properties

    /// The id number of this milestone
    let id: Int

    /// The number of this milestone
    let number: Int

    /// The state of this milestone: open, closed, all
    let state: MilestoneState

    /// The title of this milestone
    let title: String

    /// The description of this milestone.
    let description: String

    /// The user who created this milestone.
    let creator: GitHubUser

    /// The number of open issues in this milestone
    let openIssues: Int

    /// The number of closed issues in this milestone
    let closedIssues: Int

    /// The ISO8601 date string for when this milestone was created.
    let createdAt: Date

    /// The ISO8601 date string for when this milestone was updated.
    let updatedAt: Date

    /// The ISO8601 date string for when this milestone was closed.
    let closedAt: Date?

    /// The ISO8601 date string for the due of this milestone.
    let dueOn: Date?
}
