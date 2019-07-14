import Foundation

public struct BitBucketCloud: Decodable {
    /// The pull request and repository metadata
    public let metadata: BitBucketMetadata

    /// The PR metadata
    public let pr: BitBucketCloudPR

    /// The commits associated with the pull request
    public let commits: [BitBucketCloudCommit]

    /// The comments on the pull request
    public let comments: [BitBucketServerComment]

    /// The activities such as OPENING, CLOSING, MERGING or UPDATING a pull request
    public let activities: [BitBucketCloudActivity]
}

public struct BitBucketCloudPR: Decodable {
    public enum State: String, Decodable {
        case open = "OPEN"
        case merged = "MERGED"
        case declined = "DECLINED"
        case suspended = "SUPERSEDED"
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case state
        case createdOn = "created_on"
        case updatedOn = "updated_on"
        case source
        case destination
        case author
        case reviewers
        case participants
    }

    /// PR's ID
    public let id: Int

    /// Title of the pull request
    public let title: String

    /// The text describing the PR
    public let description: String

    /// The pull request's current status.
    public let state: State

    /// Date when PR was created
    public let createdOn: Date

    /// Date of last update
    public let updatedOn: Date

    /// The PR's source, The repo Danger is running on
    public let source: BitBucketCloudMergeRef

    /// The PR's destination
    public let destination: BitBucketCloudMergeRef

    /// The creator of the PR
    public let author: BitBucketCloudUser

    /// People requested as reviewers
    public let reviewers: [BitBucketCloudUser]

    /// People who have participated in the PR
    public let participants: [BitBucketCloudPRParticipant]
}

public struct BitBucketCloudMergeRef: Decodable {
    private struct Branch: Decodable, Equatable {
        let name: String
    }

    private struct Commit: Decodable, Equatable {
        let hash: String
    }

    private let branch: Branch
    private let commit: Commit

    public var branchName: String {
        return branch.name
    }

    /// Hash of the last commit
    public var commitHash: String {
        return commit.hash
    }

    public let repository: BitBucketCloudRepo
}

public struct BitBucketCloudRepo: Decodable, Equatable {
    private enum CodingKeys: String, CodingKey {
        case name
        case fullName = "full_name"
        case uuid
    }

    public let name: String

    public let fullName: String

    /// The uuid of the repository
    public let uuid: String
}

public struct BitBucketCloudPRParticipant: Decodable, Equatable {
    public enum Role: String, Decodable {
        case reviewer = "REVIEWER"
        case participant = "PARTICIPANT"
    }

    /// The user who participated in this PR
    public let user: BitBucketCloudUser

    /// How did they contribute
    public let role: Role

    /// Did they approve of the PR?
    public let approved: Bool
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

    /// The SHA for the commit
    public let hash: String

    /// The author of the commit, assumed to be the person who wrote the code.
    public let author: Author

    /// When the commit was commited to the project
    public let date: Date

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

    /// Was the comment deleted?
    public let deleted: Bool

    /// Content of the comment
    public let content: BitBucketCloudContent

    /// When the comment was created
    public let createdOn: Date

    /// When the comment was updated
    public let updatedOn: Date

    /// The user that created the comment
    public let user: BitBucketServerUser

    public let type: String

    public let id: Int

    public let inline: Inline?
}

public struct BitBucketCloudContent: Decodable, Equatable {
    public let raw: String
    public let markup: String
    public let html: String
}

public struct BitBucketCloudActivity: Decodable, Equatable {
    public let comment: BitBucketCloudPRComment?
}
