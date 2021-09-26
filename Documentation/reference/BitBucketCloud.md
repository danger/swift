# BitBucketCloud

``` swift
public struct BitBucketCloud:​ Decodable
```

## Inheritance

`Decodable`

## Properties

### `activities`

The activities such as OPENING, CLOSING, MERGING or UPDATING a pull request

``` swift
let activities:​ [Activity]
```

### `comments`

The comments on the pull request

``` swift
let comments:​ [Comment]
```

### `commits`

The commits associated with the pull request

``` swift
let commits:​ [Commit]
```

### `metadata`

The pull request and repository metadata

``` swift
let metadata:​ BitBucketMetadata
```

### `pr`

The PR metadata

``` swift
let pr:​ PullRequest
```
