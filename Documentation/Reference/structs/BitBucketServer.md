**STRUCT**

# `BitBucketServer`

```swift
public struct BitBucketServer: Decodable, Equatable
```

## Properties
### `metadata`

```swift
public let metadata: BitBucketServerMetadata
```

> The pull request and repository metadata

### `pullRequest`

```swift
public let pullRequest: BitBucketServerPR
```

> The pull request metadata

### `commits`

```swift
public let commits: [BitBucketServerCommit]
```

> The commits associated with the pull request

### `comments`

```swift
public let comments: [BitBucketServerComment]
```

> The comments on the pull request

### `activities`

```swift
public let activities: [BitBucketServerActivity]
```

> The activities such as OPENING, CLOSING, MERGING or UPDATING a pull request
