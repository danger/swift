**STRUCT**

# `RequestedReviewers`

```swift
public struct RequestedReviewers: Decodable, Equatable
```

> Represents the payload for a PR's requested reviewers value.

## Properties
### `users`

```swift
public let users: [User]
```

> The list of users of whom a review has been requested.

### `teams`

```swift
public let teams: [Team]
```

> The list of teams of whom a review has been requested.
