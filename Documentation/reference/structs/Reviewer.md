**STRUCT**

# `Reviewer`

```swift
public struct Reviewer: Decodable, Equatable
```

> A user that reviewed the PR

## Properties
### `user`

```swift
public let user: BitBucketServerUser
```

> The BitBucket Server User

### `approved`

```swift
public let approved: Bool
```

> The approval status

### `lastReviewedCommit`

```swift
public let lastReviewedCommit: String?
```

> The commit SHA for the latest commit that was reviewed
