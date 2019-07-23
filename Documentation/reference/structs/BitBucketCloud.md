**STRUCT**

# `BitBucketCloud`

```swift
public struct BitBucketCloud: Decodable
```

## Properties
### `activities`

```swift
public let activities: [Activity]
```

> The activities such as OPENING, CLOSING, MERGING or UPDATING a pull request

### `comments`

```swift
public let comments: [Comment]
```

> The comments on the pull request

### `commits`

```swift
public let commits: [Commit]
```

> The commits associated with the pull request

### `metadata`

```swift
public let metadata: BitBucketMetadata
```

> The pull request and repository metadata

### `pr`

```swift
public let pr: PullRequest // swiftlint:disable:this identifier_name
```

> The PR metadata
