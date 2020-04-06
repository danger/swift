# GitLab

``` swift
public struct GitLab: Decodable
```

## Inheritance

`Decodable`

## Enumeration Cases

### `closed`

``` swift
case closed
```

### `locked`

``` swift
case locked
```

### `merged`

``` swift
case merged
```

### `opened`

``` swift
case opened
```

### `createdAt`

``` swift
case createdAt
```

### `description`

``` swift
case description
```

### `dueDate`

``` swift
case dueDate
```

### `id`

``` swift
case id
```

### `iid`

``` swift
case iid
```

### `projectId`

``` swift
case projectId
```

### `startDate`

``` swift
case startDate
```

### `state`

``` swift
case state
```

### `title`

``` swift
case title
```

### `updatedAt`

``` swift
case updatedAt
```

### `webUrl`

``` swift
case webUrl
```

### `active`

``` swift
case active
```

### `closed`

``` swift
case closed
```

### `humanTimeEstimate`

``` swift
case humanTimeEstimate
```

### `humanTimeSpent`

``` swift
case humanTimeSpent
```

### `timeEstimate`

``` swift
case timeEstimate
```

### `totalTimeSpent`

``` swift
case totalTimeSpent
```

### `canceled`

``` swift
case canceled
```

### `failed`

``` swift
case failed
```

### `pending`

``` swift
case pending
```

### `running`

``` swift
case running
```

### `skipped`

``` swift
case skipped
```

### `success`

``` swift
case success
```

### `id`

``` swift
case id
```

### `ref`

``` swift
case ref
```

### `sha`

``` swift
case sha
```

### `status`

``` swift
case status
```

### `webUrl`

``` swift
case webUrl
```

### `allowCollaboration`

``` swift
case allowCollaboration
```

### `allowMaintainerToPush`

``` swift
case allowMaintainerToPush
```

### `approvalsBeforeMerge`

``` swift
case approvalsBeforeMerge
```

### `assignee`

``` swift
case assignee
```

### `author`

``` swift
case author
```

### `changesCount`

``` swift
case changesCount
```

### `closedAt`

``` swift
case closedAt
```

### `closedBy`

``` swift
case closedBy
```

### `description`

``` swift
case description
```

### `diffRefs`

``` swift
case diffRefs
```

### `downvotes`

``` swift
case downvotes
```

### `firstDeployedToProductionAt`

``` swift
case firstDeployedToProductionAt
```

### `forceRemoveSourceBranch`

``` swift
case forceRemoveSourceBranch
```

### `id`

``` swift
case id
```

### `iid`

``` swift
case iid
```

### `latestBuildStartedAt`

``` swift
case latestBuildStartedAt
```

### `latestBuildFinishedAt`

``` swift
case latestBuildFinishedAt
```

### `labels`

``` swift
case labels
```

### `mergeCommitSha`

``` swift
case mergeCommitSha
```

### `mergedAt`

``` swift
case mergedAt
```

### `mergedBy`

``` swift
case mergedBy
```

### `mergeOnPipelineSuccess`

``` swift
case mergeOnPipelineSuccess
```

### `milestone`

``` swift
case milestone
```

### `pipeline`

``` swift
case pipeline
```

### `projectId`

``` swift
case projectId
```

### `sha`

``` swift
case sha
```

### `shouldRemoveSourceBranch`

``` swift
case shouldRemoveSourceBranch
```

### `sourceBranch`

``` swift
case sourceBranch
```

### `sourceProjectId`

``` swift
case sourceProjectId
```

### `state`

``` swift
case state
```

### `subscribed`

``` swift
case subscribed
```

### `targetBranch`

``` swift
case targetBranch
```

### `targetProjectId`

``` swift
case targetProjectId
```

### `timeStats`

``` swift
case timeStats
```

### `title`

``` swift
case title
```

### `upvotes`

``` swift
case upvotes
```

### `userMergeData`

``` swift
case userMergeData
```

### `userNotesCount`

``` swift
case userNotesCount
```

### `webUrl`

``` swift
case webUrl
```

### `workInProgress`

``` swift
case workInProgress
```

### `avatarUrl`

``` swift
case avatarUrl
```

### `id`

``` swift
case id
```

### `name`

``` swift
case name
```

### `state`

``` swift
case state
```

### `username`

``` swift
case username
```

### `webUrl`

``` swift
case webUrl
```

### `active`

``` swift
case active
```

### `blocked`

``` swift
case blocked
```

## Properties

### `mergeRequest`

``` swift
let mergeRequest: MergeRequest
```

### `metadata`

``` swift
let metadata: Metadata
```

### `pullRequestID`

``` swift
let pullRequestID: String
```

### `repoSlug`

``` swift
let repoSlug: String
```

### `createdAt`

``` swift
let createdAt: Date
```

### `description`

``` swift
let description: String
```

### `dueDate`

``` swift
let dueDate: Date
```

### `id`

``` swift
let id: Int
```

### `iid`

``` swift
let iid: Int
```

### `projectId`

``` swift
let projectId: Int
```

### `startDate`

``` swift
let startDate: Date
```

### `state`

``` swift
let state: State
```

### `title`

``` swift
let title: String
```

### `updatedAt`

``` swift
let updatedAt: Date
```

### `webUrl`

``` swift
let webUrl: String
```

### `humanTimeEstimate`

``` swift
let humanTimeEstimate: Int?
```

### `humanTimeSpent`

``` swift
let humanTimeSpent: Int?
```

### `timeEstimate`

``` swift
let timeEstimate: Int
```

### `totalTimeSpent`

``` swift
let totalTimeSpent: Int
```

### `id`

``` swift
let id: Int
```

### `ref`

``` swift
let ref: String
```

### `sha`

``` swift
let sha: String
```

### `status`

``` swift
let status: Status
```

### `webUrl`

``` swift
let webUrl: String
```

### `allowCollaboration`

``` swift
let allowCollaboration: Bool?
```

### `allowMaintainerToPush`

``` swift
let allowMaintainerToPush: Bool?
```

### `approvalsBeforeMerge`

``` swift
let approvalsBeforeMerge: Int?
```

### `assignee`

``` swift
let assignee: User?
```

### `author`

``` swift
let author: User
```

### `changesCount`

``` swift
let changesCount: String
```

### `closedAt`

``` swift
let closedAt: Date?
```

### `closedBy`

``` swift
let closedBy: User?
```

### `description`

``` swift
let description: String
```

### `diffRefs`

``` swift
let diffRefs: DiffRefs
```

### `downvotes`

``` swift
let downvotes: Int
```

### `firstDeployedToProductionAt`

``` swift
let firstDeployedToProductionAt: Date?
```

### `forceRemoveSourceBranch`

``` swift
let forceRemoveSourceBranch: Bool
```

### `id`

``` swift
let id: Int
```

### `iid`

``` swift
let iid: Int
```

### `latestBuildFinishedAt`

``` swift
let latestBuildFinishedAt: Date?
```

### `latestBuildStartedAt`

``` swift
let latestBuildStartedAt: Date?
```

### `labels`

``` swift
let labels: [String]
```

### `mergeCommitSha`

``` swift
let mergeCommitSha: String?
```

### `mergedAt`

``` swift
let mergedAt: Date?
```

### `mergedBy`

``` swift
let mergedBy: User?
```

### `mergeOnPipelineSuccess`

``` swift
let mergeOnPipelineSuccess: Bool
```

### `milestone`

``` swift
let milestone: Milestone?
```

### `pipeline`

``` swift
let pipeline: Pipeline?
```

### `projectId`

``` swift
let projectId: Int
```

### `sha`

``` swift
let sha: String
```

### `shouldRemoveSourceBranch`

``` swift
let shouldRemoveSourceBranch: Bool?
```

### `sourceBranch`

``` swift
let sourceBranch: String
```

### `sourceProjectId`

``` swift
let sourceProjectId: Int
```

### `state`

``` swift
let state: State
```

### `subscribed`

``` swift
let subscribed: Bool
```

### `targetBranch`

``` swift
let targetBranch: String
```

### `targetProjectId`

``` swift
let targetProjectId: Int
```

### `timeStats`

``` swift
let timeStats: TimeStats
```

### `title`

``` swift
let title: String
```

### `upvotes`

``` swift
let upvotes: Int
```

### `userNotesCount`

``` swift
let userNotesCount: Int
```

### `webUrl`

``` swift
let webUrl: String
```

### `workInProgress`

``` swift
let workInProgress: Bool
```

### `userCanMerge`

``` swift
var userCanMerge: Bool
```

### `avatarUrl`

``` swift
let avatarUrl: String?
```

### `id`

``` swift
let id: Int
```

### `name`

``` swift
let name: String
```

### `state`

``` swift
let state: State
```

### `username`

``` swift
let username: String
```

### `webUrl`

``` swift
let webUrl: String
```
