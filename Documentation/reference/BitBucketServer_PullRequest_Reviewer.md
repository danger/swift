# BitBucketServer.PullRequest.Reviewer

A user that reviewed the PR

``` swift
public struct Reviewer: Decodable, Equatable
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `user`

The BitBucket Server User

``` swift
let user: User
```

### `approved`

The approval status

``` swift
let approved: Bool
```

### `lastReviewedCommit`

The commit SHA for the latest commit that was reviewed

``` swift
let lastReviewedCommit: String?
```
