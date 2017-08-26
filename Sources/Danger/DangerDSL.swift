import Foundation

// http://benscheirman.com/2017/06/ultimate-guide-to-json-parsing-with-swift-4/
// http://danger.systems/js/reference.html

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
