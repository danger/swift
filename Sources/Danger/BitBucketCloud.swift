import Foundation

public struct BitBucketCloud: Decodable {
    /// The activities such as OPENING, CLOSING, MERGING or UPDATING a pull request
    public let activities: [BitBucketCloudActivity]

    /// The comments on the pull request
    public let comments: [BitBucketServerComment]

    /// The commits associated with the pull request
    public let commits: [BitBucketCloudCommit]

    /// The pull request and repository metadata
    public let metadata: BitBucketMetadata

    /// The PR metadata
    public let pr: BitBucketCloudPR
}

public struct BitBucketCloudPR: Decodable {
    public enum State: String, Decodable {
        case declined = "DECLINED"
        case merged = "MERGED"
        case open = "OPEN"
        case suspended = "SUPERSEDED"
    }

    private enum CodingKeys: String, CodingKey {
        case author
        case createdOn = "created_on"
        case description
        case destination
        case id
        case participants
        case reviewers
        case source
        case state
        case title
        case updatedOn = "updated_on"
    }

    /// The creator of the PR
    public let author: BitBucketCloudUser

    /// Date when PR was created
    public let createdOn: Date

    /// The text describing the PR
    public let description: String

    /// The PR's destination
    public let destination: BitBucketCloudMergeRef

    /// PR's ID
    public let id: Int

    /// People who have participated in the PR
    public let participants: [BitBucketCloudPRParticipant]

    /// People requested as reviewers
    public let reviewers: [BitBucketCloudUser]

    /// The PR's source, The repo Danger is running on
    public let source: BitBucketCloudMergeRef

    /// The pull request's current status.
    public let state: State

    /// Title of the pull request
    public let title: String

    /// Date of last update
    public let updatedOn: Date
}

public struct BitBucketCloudMergeRef: Decodable {
    private struct Branch: Decodable, Equatable {
        let name: String
    }

    private struct Commit: Decodable, Equatable {
        let hash: String
    }

    private let branch: Branch

    public var branchName: String {
        return branch.name
    }

    private let commit: Commit

    /// Hash of the last commit
    public var commitHash: String {
        return commit.hash
    }

    public let repository: BitBucketCloudRepo
}

public struct BitBucketCloudRepo: Decodable, Equatable {
    private enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case name
        case uuid
    }

    public let fullName: String

    public let name: String

    /// The uuid of the repository
    public let uuid: String
}

public struct BitBucketCloudPRParticipant: Decodable, Equatable {
    public enum Role: String, Decodable {
        case reviewer = "REVIEWER"
        case participant = "PARTICIPANT"
    }

    /// Did they approve of the PR?
    public let approved: Bool

    /// How did they contribute
    public let role: Role

    /// The user who participated in this PR
    public let user: BitBucketCloudUser
}

public struct BitBucketCloudUser: Decodable, Equatable {
    private enum CodingKeys: String, CodingKey {
        case accountId = "account_id"
        case displayName = "display_name"
        case nickname
        case uuid
    }

    /// The acount id of the user
    public let accountId: String

    /// The display name of user
    public let displayName: String

    /// The nick name of the user
    public let nickname: String

    /// The uuid of the user
    public let uuid: String
}

public struct BitBucketCloudCommit: Decodable, Equatable {
    public struct Author: Decodable, Equatable {
        /// Format: `Foo Bar <foo@bar.com>`
        let raw: String

        /// The user that created the commit
        let user: BitBucketCloudUser
    }

    public struct Parent {
        /// The full SHA
        let hash: String
    }

    /// The author of the commit, assumed to be the person who wrote the code.
    public let author: Author

    /// When the commit was commited to the project
    public let date: Date

    /// The SHA for the commit
    public let hash: String

    /// The commit's message
    public let message: String
}

public struct BitBucketCloudPRComment: Decodable, Equatable {
    public struct Inline: Decodable, Equatable {
        public let from: Int
        public let to: Int
        public let path: String
    }

    private enum CodingKeys: String, CodingKey {
        case deleted
        case content
        case createdOn = "created_on"
        case user
        case updatedOn = "updated_on"
        case type
        case id
        case inline
    }

    /// Content of the comment
    public let content: BitBucketCloudContent

    /// When the comment was created
    public let createdOn: Date

    /// Was the comment deleted?
    public let deleted: Bool

    public let id: Int

    public let inline: Inline?

    public let type: String

    /// When the comment was updated
    public let updatedOn: Date

    /// The user that created the comment
    public let user: BitBucketServerUser
}

public struct BitBucketCloudContent: Decodable, Equatable {
    public let html: String
    public let markup: String
    public let raw: String
}

public struct BitBucketCloudActivity: Decodable, Equatable {
    public let comment: BitBucketCloudPRComment?
}
