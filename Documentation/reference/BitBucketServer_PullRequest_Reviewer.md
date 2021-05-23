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
public let user: User
```

### `approved`

The approval status

``` swift
public let approved: Bool
```

### `lastReviewedCommit`

The commit SHA for the latest commit that was reviewed

``` swift
public let lastReviewedCommit: String?
```
