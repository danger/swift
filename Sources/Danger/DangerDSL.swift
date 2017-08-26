import Foundation

// http://benscheirman.com/2017/06/ultimate-guide-to-json-parsing-with-swift-4/
// http://danger.systems/js/reference.html

struct DSL: Decodable {
    let danger: DangerDSL
}

public struct DangerDSL: Decodable {
    public let git: Git
    public let github: GitHub
}

public struct Git: Decodable {
    enum CodingKeys: String, CodingKey {
        case modifiedFiles = "modified_files"
        case createdFiles = "created_files"
        case deletedFiles = "deleted_files"
    }

    public let modifiedFiles: [String]
    public let createdFiles: [String]
    public let deletedFiles: [String]
}

public struct GitHub: Decodable {

    enum CodingKeys: String, CodingKey {
        case pullRequest = "pr"
    }

    public let pullRequest: GitHubPR

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
        case additions
        case deletions
        case state
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

    // MARK: - State

    public enum State: String, Decodable {
        case open
        case closed
        case merged
        case locked
    }

    // MARK: - Properties

    /// The number of the pull request
    public let number: Int

    /// The title of the pull request
    public let title: String

    /// The markdown body message of the pull request
    public let body: String

    /// The user who submitted the pull request
    public let user: GitHubUser

    /// The user who is assigned to the pull request
    public let assignee: GitHubUser

    /// The users who are assigned to the pull request
    public let assignees: [GitHubUser]

    /// The ISO6801 date string for when the pull request was created.
    public let createdAt: String

    /// The ISO6801 date string for when the pull request was updated.
    public let updatedAt: String

    /// The ISO6801 date string for when the pull request was closed.
    public let closedAt: String?

    /// The ISO6801 date string for when the pull request was merged.
    public let mergedAt: String?

    /// The state for the pull request: open, closed, locked, merged.
    public let state: State

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

    /// The number of added lines in the pull request
    public let additions: Int

    /// The number of deleted lines in the pull request
    public let deletions: Int

    /// The number of files changed in the pull request
    public let changedFiles: Int

}

// MARK: - GitHubUser

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


//
//GitHubPRDSL {
//
//    // The number of additional lines in the PR
//    additions: number
//
//    // The User who is assigned the PR
//    assignee: GitHubUser
//
//    // The Users who are assigned to the PR
//    assignees: GitHubUser
//
//    // Merge reference for _this_ repo.
//    base: GitHubMergeRef
//
//    // The markdown body message of the PR
//    body: string
//
//    // The number of changed files in the PR
//    changed_files: number
//
//    // optional ISO6801 Date string for when PR was closed
//    closed_at: string | null
//
//    // The number of comments on the PR
//    comments: number
//
//    // The number of commits in the PR
//    commits: number
//
//    // ISO6801 Date string for when PR was created
//    created_at: string
//
//    // The number of deleted lines in the PR
//    deletions: number
//
//    // Merge reference for the _other_ repo.
//    head: GitHubMergeRef
//
//    // Has the PR been locked to contributors only?
//    locked: boolean
//
//    // Has the PR been merged yet?
//    merged: boolean
//
//    // Optional ISO6801 Date string for when PR was merged. Danger probably shouldn't be running in this state.
//    merged_at: string | null
//
//    // The UUID for the PR
//    number: number
//
//    // The number of review-specific comments on the PR
//    review_comments: number
//
//    // The state for the PR
//    state: "closed" | "open" | "locked" | "merged"
//
//    // The title of the PR
//    title: string
//
//    // ISO6801 Date string for when PR was updated
//    updated_at: string
//
//    // The User who submitted the PR
//    user: GitHubUser
//
//}
//// A GitHub Repo
//
//GitHubRepo {
//
//    // Is someone assigned to this PR?
//    assignee: GitHubUser
//
//    // Are there people assigned to this PR?
//    assignees: GitHubUser
//
//    // The textual description of the repo
//    description: string
//
//    // Is the repo a fork?
//    fork: boolean
//
//    // The full name of the owner + repo, e.g. "Danger/Danger-JS"
//    full_name: string
//
//    // The root web URL for the repo, e.g. https://github.com/artsy/emission
//    html_url: string
//
//    // Generic UUID
//    id: number
//
//    // The name of the repo, e.g. "Danger-JS"
//    name: string
//
//    // The owner of the repo
//    owner: GitHubUser
//
//    // Is the repo publicly accessible?
//    private: boolean
//
//}
//// GitHubReview While a review is pending, it will only have a user. Once a review is complete, the rest of the review attributes will be present
//
//GitHubReview {
//
//    // If there is a review, the body of the review
//    body?: string
//
//    // If there is a review, the commit ID this review was made on
//    commit_id?: string
//
//    // If there is a review, this provides the ID for it
//    id?: number
//
//    // The state of the review APPROVED, REQUEST_CHANGES, COMMENT or PENDING
//    state?: "APPROVED" | "REQUEST_CHANGES" | "COMMENT" | "PENDING"
//
//    // The user requested to review, or the user who has completed the review
//    user: GitHubUser
//
//}
//// A GitHub user account.
//
//GitHubUser {
//
//    // Generic UUID
//    id: number
//
//    // The handle for the user/org
//    login: string
//
//    // Whether the user is an org, or a user
//    type: "User" | "Organization"
//
//}
