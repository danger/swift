# BitBucketServer

``` swift
public struct BitBucketServer:​ Decodable, Equatable
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `metadata`

The pull request and repository metadata

``` swift
let metadata:​ BitBucketMetadata
```

### `pullRequest`

The pull request metadata

``` swift
let pullRequest:​ PullRequest
```

### `commits`

The commits associated with the pull request

``` swift
let commits:​ [Commit]
```

### `comments`

The comments on the pull request

``` swift
let comments:​ [Comment]
```

### `activities`

The activities such as OPENING, CLOSING, MERGING or UPDATING a pull request

``` swift
let activities:​ [Activity]
```
