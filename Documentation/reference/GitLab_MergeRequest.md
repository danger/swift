# GitLab.MergeRequest

``` swift
struct MergeRequest:​ Decodable, Equatable
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `allowCollaboration`

``` swift
let allowCollaboration:​ Bool?
```

### `allowMaintainerToPush`

``` swift
let allowMaintainerToPush:​ Bool?
```

### `approvalsBeforeMerge`

``` swift
let approvalsBeforeMerge:​ Int?
```

### `assignee`

``` swift
let assignee:​ User?
```

### `assignees`

``` swift
let assignees:​ [User]?
```

### `author`

``` swift
let author:​ User
```

### `changesCount`

``` swift
let changesCount:​ String
```

### `closedAt`

``` swift
let closedAt:​ Date?
```

### `closedBy`

``` swift
let closedBy:​ User?
```

### `description`

``` swift
let description:​ String
```

### `diffRefs`

``` swift
let diffRefs:​ DiffRefs
```

### `downvotes`

``` swift
let downvotes:​ Int
```

### `firstDeployedToProductionAt`

``` swift
let firstDeployedToProductionAt:​ Date?
```

### `forceRemoveSourceBranch`

``` swift
let forceRemoveSourceBranch:​ Bool?
```

### `id`

``` swift
let id:​ Int
```

### `iid`

``` swift
let iid:​ Int
```

### `latestBuildFinishedAt`

``` swift
let latestBuildFinishedAt:​ Date?
```

### `latestBuildStartedAt`

``` swift
let latestBuildStartedAt:​ Date?
```

### `labels`

``` swift
let labels:​ [String]
```

### `mergeCommitSha`

``` swift
let mergeCommitSha:​ String?
```

### `mergedAt`

``` swift
let mergedAt:​ Date?
```

### `mergedBy`

``` swift
let mergedBy:​ User?
```

### `mergeOnPipelineSuccess`

``` swift
let mergeOnPipelineSuccess:​ Bool
```

### `milestone`

``` swift
let milestone:​ Milestone?
```

### `pipeline`

``` swift
let pipeline:​ Pipeline?
```

### `projectId`

``` swift
let projectId:​ Int
```

### `sha`

``` swift
let sha:​ String
```

### `shouldRemoveSourceBranch`

``` swift
let shouldRemoveSourceBranch:​ Bool?
```

### `sourceBranch`

``` swift
let sourceBranch:​ String
```

### `sourceProjectId`

``` swift
let sourceProjectId:​ Int
```

### `state`

``` swift
let state:​ State
```

### `subscribed`

``` swift
let subscribed:​ Bool
```

### `targetBranch`

``` swift
let targetBranch:​ String
```

### `targetProjectId`

``` swift
let targetProjectId:​ Int
```

### `timeStats`

``` swift
let timeStats:​ TimeStats
```

### `title`

``` swift
let title:​ String
```

### `upvotes`

``` swift
let upvotes:​ Int
```

### `userNotesCount`

``` swift
let userNotesCount:​ Int
```

### `webUrl`

``` swift
let webUrl:​ String
```

### `workInProgress`

``` swift
let workInProgress:​ Bool
```

### `userMergeData`

``` swift
let userMergeData:​ UserMergeData
```

### `userCanMerge`

``` swift
var userCanMerge:​ Bool
```
