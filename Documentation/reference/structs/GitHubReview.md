**STRUCT**

# `GitHubReview`

```swift
public struct GitHubReview: Decodable, Equatable
```

## Properties
### `user`

```swift
public let user: GitHubUser
```

> The user who has completed the review or has been requested to review.

### `id`

```swift
public let id: Int?
```

> The id for the review (if a review was made).

### `body`

```swift
public let body: String?
```

> The body of the review (if a review was made).

### `commitId`

```swift
public let commitId: String?
```

> The commit ID the review was made on (if a review was made).

### `state`

```swift
public let state: ReviewState?
```

> The state of the review (if a review was made).
