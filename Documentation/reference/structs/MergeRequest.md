**STRUCT**

# `MergeRequest`

```swift
public struct MergeRequest: Decodable, Equatable
```

## Properties
### `allowCollaboration`

```swift
public let allowCollaboration: Bool?
```

### `allowMaintainerToPush`

```swift
public let allowMaintainerToPush: Bool?
```

### `approvalsBeforeMerge`

```swift
public let approvalsBeforeMerge: Int?
```

### `assignee`

```swift
public let assignee: User?
```

### `author`

```swift
public let author: User
```

### `changesCount`

```swift
public let changesCount: String
```

### `closedAt`

```swift
public let closedAt: Date?
```

### `closedBy`

```swift
public let closedBy: User?
```

### `description`

```swift
public let description: String
```

### `diffRefs`

```swift
public let diffRefs: DiffRefs
```

### `downvotes`

```swift
public let downvotes: Int
```

### `firstDeployedToProductionAt`

```swift
public let firstDeployedToProductionAt: Date?
```

### `forceRemoveSourceBranch`

```swift
public let forceRemoveSourceBranch: Bool
```

### `id`

```swift
public let id: Int // swiftlint:disable:this identifier_name
```

### `iid`

```swift
public let iid: Int
```

### `latestBuildFinishedAt`

```swift
public let latestBuildFinishedAt: Date?
```

### `latestBuildStartedAt`

```swift
public let latestBuildStartedAt: Date?
```

### `labels`

```swift
public let labels: [String]
```

### `mergeCommitSha`

```swift
public let mergeCommitSha: String?
```

### `mergedAt`

```swift
public let mergedAt: Date?
```

### `mergedBy`

```swift
public let mergedBy: User?
```

### `mergeOnPipelineSuccess`

```swift
public let mergeOnPipelineSuccess: Bool
```

### `milestone`

```swift
public let milestone: Milestone?
```

### `pipeline`

```swift
public let pipeline: Pipeline?
```

### `projectId`

```swift
public let projectId: Int
```

### `sha`

```swift
public let sha: String
```

### `shouldRemoveSourceBranch`

```swift
public let shouldRemoveSourceBranch: Bool?
```

### `sourceBranch`

```swift
public let sourceBranch: String
```

### `sourceProjectId`

```swift
public let sourceProjectId: Int
```

### `state`

```swift
public let state: State
```

### `subscribed`

```swift
public let subscribed: Bool
```

### `targetBranch`

```swift
public let targetBranch: String
```

### `targetProjectId`

```swift
public let targetProjectId: Int
```

### `timeStats`

```swift
public let timeStats: TimeStats
```

### `title`

```swift
public let title: String
```

### `upvotes`

```swift
public let upvotes: Int
```

### `userNotesCount`

```swift
public let userNotesCount: Int
```

### `webUrl`

```swift
public let webUrl: String
```

### `workInProgress`

```swift
public let workInProgress: Bool
```

### `userCanMerge`

```swift
public var userCanMerge: Bool
```
