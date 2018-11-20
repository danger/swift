**STRUCT**

# `GitHubRequestedReviewers`

```swift
public struct GitHubRequestedReviewers: Decodable, Equatable
```

> Represents the payload for a PR's requested reviewers value.

## Properties
### `users`

```swift
public let users: [GitHubUser]
```

> The list of users of whom a review has been requested.

### `teams`

```swift
public let teams: [GitHubTeam]
```

> The list of teams of whom a review has been requested.
