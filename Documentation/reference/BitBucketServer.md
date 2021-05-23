# BitBucketServer

``` swift
public struct BitBucketServer: Decodable, Equatable 
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `metadata`

The pull request and repository metadata

``` swift
public let metadata: BitBucketMetadata
```

### `pullRequest`

The pull request metadata

``` swift
public let pullRequest: PullRequest
```

### `commits`

The commits associated with the pull request

``` swift
public let commits: [Commit]
```

### `comments`

The comments on the pull request

``` swift
public let comments: [Comment]
```

### `activities`

The activities such as OPENING, CLOSING, MERGING or UPDATING a pull request

``` swift
public let activities: [Activity]
```
