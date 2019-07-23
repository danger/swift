**STRUCT**

# `GitHub`

```swift
public struct GitHub: Decodable
```

> The GitHub metadata for your pull request.

## Properties
### `issue`

```swift
public let issue: Issue
```

### `pullRequest`

```swift
public let pullRequest: PullRequest
```

### `commits`

```swift
public let commits: [Commit]
```

### `reviews`

```swift
public let reviews: [Review]
```

### `requestedReviewers`

```swift
public let requestedReviewers: RequestedReviewers
```

### `api`

```swift
public internal(set) var api: Octokit!
```
