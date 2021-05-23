# BitBucketCloud

``` swift
public struct BitBucketCloud: Decodable 
```

## Inheritance

`Decodable`

## Properties

### `activities`

The activities such as OPENING, CLOSING, MERGING or UPDATING a pull request

``` swift
public let activities: [Activity]
```

### `comments`

The comments on the pull request

``` swift
public let comments: [Comment]
```

### `commits`

The commits associated with the pull request

``` swift
public let commits: [Commit]
```

### `metadata`

The pull request and repository metadata

``` swift
public let metadata: BitBucketMetadata
```

### `pr`

The PR metadata

``` swift
public let pr: PullRequest
```
