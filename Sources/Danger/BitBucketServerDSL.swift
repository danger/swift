import Foundation

// swiftlint:disable nesting

public struct BitBucketServer: Decodable, Equatable {
    enum CodingKeys: String, CodingKey {
        case metadata
        case pullRequest = "pr"
        case commits
        case comments
        case activities
    }

    /// The pull request and repository metadata
    public let metadata: BitBucketMetadata

    /// The pull request metadata
    public let pullRequest: PullRequest

    /// The commits associated with the pull request
    public let commits: [Commit]

    /// The comments on the pull request
    public let comments: [Comment]

    /// The activities such as OPENING, CLOSING, MERGING or UPDATING a pull request
    public let activities: [Activity]
}

public extension BitBucketServer {
    struct Activity: Decodable, Equatable {
        enum CodingKeys: String, CodingKey {
            case id
            case createdAt = "createdDate"
            case user
            case action
            case commentAction
        }

        /// The activity's ID
        public let id: Int

        /// Date activity created as number of mili seconds since the unix epoch
        public let createdAt: Int

        /// The user that triggered the activity.
        public let user: User

        /// The action the activity describes (e.g. "COMMENTED").
        public let action: String

        /// In case the action was "COMMENTED" it will state the command specific action (e.g. "CREATED").
        public let commentAction: String?
    }
}

public extension BitBucketServer {
    struct Comment: Decodable, Equatable {
        enum CodingKeys: String, CodingKey {
            case id
            case createdAt = "createdDate"
            case user
            case action
            case fromHash
            case previousFromHash
            case toHash
            case previousToHash
            case commentAction
            case comment
        }

        /// The comment's id
        public let id: Int

        /// Date comment created as number of mili seconds since the unix epoch
        public let createdAt: Int

        /// The comment's author
        public let user: User

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
        public let comment: Detail?

        public struct Detail: Decodable, Equatable {
            enum CodingKeys: String, CodingKey {
                case id
                case version
                case text
                case author
                case createdAt = "createdDate"
                case updatedAt = "updatedDate"
                case comments
                case properties
                case tasks
            }

            /// The comment's id
            public let id: Int

            /// The comment's version
            public let version: Int

            /// The comment content
            public let text: String

            /// The author of the comment
            public let author: User

            /// Date comment created as number of mili seconds since the unix epoch
            public let createdAt: Int

            /// Date comment updated as number of mili seconds since the unix epoch
            public let updatedAt: Int

            /// Replys to the comment
            public let comments: [Detail]

            /// Properties associated with the comment
            public let properties: InnerProperties

            /// Tasks associated with the comment
            public let tasks: [Task]?

            public struct Task: Decodable, Equatable {
                enum CodingKeys: String, CodingKey {
                    case id
                    case createdAt = "createdDate"
                    case text
                    case state
                    case author
                }

                /// The tasks ID
                public let id: Int

                /// Date activity created as number of mili seconds since the unix epoch
                public let createdAt: Int

                /// The text of the task
                public let text: String

                /// The state of the task (e.g. "OPEN")
                public let state: String

                /// The author of the comment
                public let author: User
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

public extension BitBucketServer {
    struct Commit: Decodable, Equatable {
        /// The SHA for the commit
        public let id: String

        /// The shortened SHA for the commit
        public let displayId: String

        /// The author of the commit, assumed to be the person who wrote the code.
        public let author: User

        /// The UNIX timestamp for when the commit was authored
        public let authorTimestamp: Int

        /// The author of the commit, assumed to be the person who commited/merged the code into a project.
        public let committer: User?

        /// When the commit was commited to the project
        public let committerTimestamp: Int?

        /// The commit's message
        public let message: String

        /// The commit's parents
        public let parents: [Parent]

        public struct Parent: Decodable, Equatable {
            /// The SHA for the commit
            public let id: String

            /// The shortened SHA for the commit
            public let displayId: String
        }
    }
}

public extension BitBucketServer {
    struct PullRequest: Decodable, Equatable {
        enum CodingKeys: String, CodingKey {
            case id
            case version
            case title
            case description
            case state
            case open
            case closed
            case createdAt = "createdDate"
            case updatedAt = "updatedDate"
            case fromRef
            case toRef
            case isLocked = "locked"
            case author
            case reviewers
            case participants
        }

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
        public let fromRef: MergeRef

        /// The repo Danger is running on
        public let toRef: MergeRef

        /// Is the PR locked?
        public let isLocked: Bool

        /// The creator of the PR
        public let author: Participant

        /// People requested as reviewers
        public let reviewers: [Reviewer]

        /// People who have participated in the PR
        public let participants: [Participant]

        /// A user that is parecipating in the PR
        public struct Participant: Decodable, Equatable {
            /// The BitBucket Server User
            public let user: User
        }

        /// A user that reviewed the PR
        public struct Reviewer: Decodable, Equatable {
            /// The BitBucket Server User
            public let user: User

            /// The approval status
            public let approved: Bool

            /// The commit SHA for the latest commit that was reviewed
            public let lastReviewedCommit: String?
        }
    }
}

public extension BitBucketServer {
    struct MergeRef: Decodable, Equatable {
        /// The branch name
        public let id: String

        /// The human readable branch name
        public let displayId: String

        /// The SHA for the latest commit
        public let latestCommit: String

        /// Info of the associated repository
        public let repository: Repo
    }
}

public extension BitBucketServer {
    struct Repo: Decodable, Equatable {
        enum CodingKeys: String, CodingKey {
            case name
            case slug
            case scmId
            case isPublic = "public"
            case forkable
            case project
        }

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
        public let project: Project
    }
}

public extension BitBucketServer {
    struct Project: Decodable, Equatable {
        enum CodingKeys: String, CodingKey {
            case id
            case key
            case name
            case isPublic = "public"
            case type
        }

        /// The project unique id
        public let id: Int

        /// The project's human readable project key
        public let key: String

        /// The name of the project
        public let name: String

        /// Is the project publicly available
        public let isPublic: Bool?

        // The project's type
        public let type: String
    }
}

public extension BitBucketServer {
    struct User: Decodable, Equatable {
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
