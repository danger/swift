# GitHub.PullRequest

``` swift
public struct PullRequest: Decodable, Equatable 
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `number`

The number of the pull request.

``` swift
public let number: Int
```

### `title`

The title of the pull request.

``` swift
public let title: String
```

### `body`

The markdown body message of the pull request.

``` swift
public let body: String?
```

### `user`

The user who submitted the pull request.

``` swift
public let user: User
```

### `assignee`

The user who is assigned to the pull request.

``` swift
public let assignee: User?
```

### `assignees`

The users who are assigned to the pull request.

``` swift
public let assignees: [User]?
```

### `createdAt`

The ISO8601 date string for when the pull request was created.

``` swift
public let createdAt: Date
```

### `updatedAt`

The ISO8601 date string for when the pull request was updated.

``` swift
public let updatedAt: Date
```

### `closedAt`

The ISO8601 date string for when the pull request was closed.

``` swift
public let closedAt: Date?
```

### `mergedAt`

The ISO8601 date string for when the pull request was merged.

``` swift
public let mergedAt: Date?
```

### `head`

The merge reference for the *other* repo.

``` swift
public let head: MergeRef
```

### `base`

The merge reference for *this* repo.

``` swift
public let base: MergeRef
```

### `state`

The state for the pull request:​ open, closed, locked, merged.

``` swift
public let state: PullRequestState
```

### `isLocked`

A boolean indicating if the pull request has been locked to contributors only.

``` swift
public let isLocked: Bool
```

### `isMerged`

A boolean indicating if the pull request has been merged.

``` swift
public let isMerged: Bool?
```

### `commitCount`

The number of commits in the pull request.

``` swift
public let commitCount: Int?
```

### `commentCount`

The number of comments in the pull request.

``` swift
public let commentCount: Int?
```

### `reviewCommentCount`

The number of review-specific comments in the pull request.

``` swift
public let reviewCommentCount: Int?
```

### `additions`

The number of added lines in the pull request.

``` swift
public let additions: Int?
```

### `deletions`

The number of deleted lines in the pull request.

``` swift
public let deletions: Int?
```

### `changedFiles`

The number of files changed in the pull request.

``` swift
public let changedFiles: Int?
```

### `milestone`

The milestone of the pull request

``` swift
public let milestone: Milestone?
```

### `htmlUrl`

The link back to this PR as user-facing

``` swift
public let htmlUrl: String
```

### `draft`

The draft state of the pull request

``` swift
public let draft: Bool?
```

### `links`

Possible link relations

``` swift
public let links: Link
```
