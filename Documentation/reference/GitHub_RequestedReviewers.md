# GitHub.RequestedReviewers

Represents the payload for a PR's requested reviewers value.

``` swift
public struct RequestedReviewers: Decodable, Equatable 
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `users`

The list of users of whom a review has been requested.

``` swift
public let users: [User]
```

### `teams`

The list of teams of whom a review has been requested.

``` swift
public let teams: [Team]
```
