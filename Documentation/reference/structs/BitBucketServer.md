**STRUCT**

# `BitBucketServer`

```swift
public struct BitBucketServer: Decodable, Equatable
```

## Properties
### `metadata`

```swift
public let metadata: BitBucketMetadata
```

> The pull request and repository metadata

### `pullRequest`

```swift
public let pullRequest: PullRequest
```

> The pull request metadata

### `commits`

```swift
public let commits: [Commit]
```

> The commits associated with the pull request

### `comments`

```swift
public let comments: [Comment]
```

> The comments on the pull request

### `activities`

```swift
public let activities: [Activity]
```

> The activities such as OPENING, CLOSING, MERGING or UPDATING a pull request
