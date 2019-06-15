import Cocoa

public struct GitLab: Decodable {
    public enum CodingKeys: String, CodingKey {
        case metadata
        case mergeRequest = "mr"
    }

    public let metadata: GitLabMetadata
    public let mergeRequest: GitLabMergeRequest
}

public struct GitLabMetadata: Decodable, Equatable {
    public let pullRequestID: String
    public let repoSlug: String
}

public struct GitLabMergeRequest: Decodable, Equatable {
    public enum State: String, Decodable {
        case closed
        case open
        case locked
        case merged
    }

    public struct Milestone: Decodable, Equatable {
        public enum CodingKeys: String, CodingKey {
            case id
            case iid
            case projectId = "project_id"
            case title
            case description
            case state
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case dueDate = "due_date"
            case startDate = "start_date"
            case webUrl = "web_url"
        }

        public enum State: String, Decodable {
            case closed
        }

        public let id: Int
        public let iid: Int
        public let projectId: Int
        public let title: String
        public let description: String
        public let state: State
        public let createdAt: Date
        public let updatedAt: Date
        public let dueDate: Date
        public let startDate: Date
        public let webUrl: String
    }

    public struct TimeStats: Decodable, Equatable {
        public enum CodingKeys: String, CodingKey {
            case timeEstimate = "time_estimate"
            case totalTimeSpent = "total_time_spent"
            case humanTimeEstimate = "human_time_estimate"
            case humanTimeSpent = "human_total_time_spent"
        }

        public let timeEstimate: Int
        public let totalTimeSpent: Int
        public let humanTimeEstimate: Int?
        public let humanTimeSpent: Int?
    }

    struct UserMergeData: Decodable, Equatable {
        enum CodingKeys: String, CodingKey {
            case canMerge = "can_merge"
        }

        let canMerge: Bool
    }

    public struct DiffRefs: Decodable, Equatable {
        enum CodingKeys: String, CodingKey {
            case baseSha = "base_sha"
            case headSha = "head_sha"
            case startSha = "start_sha"
        }

        let baseSha: String
        let headSha: String
        let startSha: String
    }

    public struct Pipeline: Decodable, Equatable {
        public enum Status: String, Decodable {
            case success
        }

        public enum CodingKeys: String, CodingKey {
            case id
            case sha
            case ref
            case status
            case webUrl = "web_url"
        }

        public let id: Int
        public let sha: String
        public let ref: String
        public let status: Status
        public let webUrl: String
    }

    public enum CodingKeys: String, CodingKey {
        case allowCollaboration = "allow_collaboration"
        case allowMaintainerToPush = "allow_maintainer_to_push"
        case approvalsBeforeMerge = "approvals_before_merge"
        case assignee
        case author
        case changesCount = "changes_count"
        case closedAt = "closed_at"
        case closedBy = "closed_by"
        case description
        case diffRefs = "diff_refs"
        case downvotes
        case firstDeployedToProductionAt = "first_deployed_to_production_at"
        case forceRemoveSourceBranch = "force_remove_source_branch"
        case id
        case iid
        case latestBuildStartedAt = "latest_build_started_at"
        case latestBuildFinishedAt = "latest_build_finished_at"
        case labels
        case mergeCommitSha = "merge_commit_sha"
        case mergedAt = "merged_at"
        case mergedBy = "merged_by"
        case mergeOnPipelineSuccess = "merge_when_pipeline_succeeds"
        case milestone
        case pipeline
        case projectId = "project_id"
        case sha
        case shouldRemoveSourceBranch = "should_remove_source_branch"
        case sourceBranch = "source_branch"
        case sourceProjectId = "source_project_id"
        case state
        case subscribed
        case targetBranch = "target_branch"
        case targetProjectId = "target_project_id"
        case timeStats = "time_stats"
        case title
        case upvotes
        case userMergeData = "user"
        case userNotesCount = "user_notes_count"
        case webUrl = "web_url"
        case workInProgress = "work_in_progress"
    }

    public let allowCollaboration: Bool
    public let allowMaintainerToPush: Bool
    public let approvalsBeforeMerge: Int?
    public let assignee: GitLabUser?
    public let author: GitLabUser
    public let changesCount: String
    public let closedAt: Date?
    public let closedBy: GitLabUser?
    public let description: String
    public let diffRefs: DiffRefs
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
    public let mergedBy: GitLabUser?
    public let mergeOnPipelineSuccess: Bool
    public let milestone: Milestone?
    public let pipeline: Pipeline
    public let projectId: Int
    public let sha: String
    public let shouldRemoveSourceBranch: Bool?
    public let sourceBranch: String
    public let sourceProjectId: Int
    public let state: State
    public let subscribed: Bool
    public let targetBranch: String
    public let targetProjectId: Int
    public let timeStats: TimeStats
    public let title: String
    public let upvotes: Int
    public let userNotesCount: Int
    public let webUrl: String
    public let workInProgress: Bool

    let userMergeData: UserMergeData

    public var userCanMerge: Bool {
        return userMergeData.canMerge
    }
}

public struct GitLabUser: Decodable, Equatable {
    public enum CodingKeys: String, CodingKey {
        case id
        case name
        case username
        case state
        case avatarUrl = "avatar_url"
        case webUrl = "web_url"
    }

    public enum State: String, Decodable {
        case active
    }

    public let id: Int
    public let name: String
    public let username: String
    public let state: State
    public let avatarUrl: String?
    public let webUrl: String
}
