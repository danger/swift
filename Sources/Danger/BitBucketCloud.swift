import Foundation

// swiftlint:disable nesting

public struct BitBucketCloud: Decodable {
    /// The activities such as OPENING, CLOSING, MERGING or UPDATING a pull request
    public let activities: [Activity]

    /// The comments on the pull request
    public let comments: [Comment]

    /// The commits associated with the pull request
    public let commits: [Commit]

    /// The pull request and repository metadata
    public let metadata: BitBucketMetadata

    /// The PR metadata
    public let pr: PullRequest // swiftlint:disable:this identifier_name
}

extension BitBucketCloud {
    public struct PullRequest: Decodable {
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
            case id // swiftlint:disable:this identifier_name
            case participants
            case reviewers
            case source
            case state
            case title
            case updatedOn = "updated_on"
        }

        public struct Participant: Decodable, Equatable {
            public enum Role: String, Decodable {
                case reviewer = "REVIEWER"
                case participant = "PARTICIPANT"
            }

            /// Did they approve of the PR?
            public let approved: Bool

            /// How did they contribute
            public let role: Role

            /// The user who participated in this PR
            public let user: User
        }

        /// The creator of the PR
        public let author: User

        /// Date when PR was created
        public let createdOn: Date

        /// The text describing the PR
        public let description: String

        /// The PR's destination
        public let destination: MergeRef

        /// PR's ID
        public let id: Int // swiftlint:disable:this identifier_name

        /// People who have participated in the PR
        public let participants: [Participant]

        /// People requested as reviewers
        public let reviewers: [User]

        /// The PR's source, The repo Danger is running on
        public let source: MergeRef

        /// The pull request's current status.
        public let state: State

        /// Title of the pull request
        public let title: String

        /// Date of last update
        public let updatedOn: Date
    }
}

extension BitBucketCloud {
    public struct MergeRef: Decodable {
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

        public let repository: Repo
    }
}

extension BitBucketCloud {
    public struct Repo: Decodable, Equatable {
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
}

extension BitBucketCloud {
    public struct User: Decodable, Equatable {
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
}

extension BitBucketCloud {
    public struct Commit: Decodable, Equatable {
        public struct Author: Decodable, Equatable {
            /// Format: `Foo Bar <foo@bar.com>`
            let raw: String

            /// The user that created the commit
            let user: User
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
}

extension BitBucketCloud {
    public struct Comment: Decodable, Equatable {
        public struct Inline: Decodable, Equatable {
            public let from: Int?
            public let to: Int? // swiftlint:disable:this identifier_name
            public let path: String?
        }

        private enum CodingKeys: String, CodingKey {
            case deleted
            case content
            case createdOn = "created_on"
            case user
            case updatedOn = "updated_on"
            case type
            case id // swiftlint:disable:this identifier_name
            case inline
        }

        /// Content of the comment
        public let content: Content

        /// When the comment was created
        public let createdOn: Date

        /// Was the comment deleted?
        public let deleted: Bool

        public let id: Int // swiftlint:disable:this identifier_name

        public let inline: Inline?

        public let type: String

        /// When the comment was updated
        public let updatedOn: Date

        /// The user that created the comment
        public let user: User
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
        public let comment: Comment?
    }
}
