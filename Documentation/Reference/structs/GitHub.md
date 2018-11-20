**STRUCT**

# `GitHub`

```swift
public struct GitHub: Decodable
```

> The GitHub metadata for your pull request.

## Properties
### `issue`

```swift
public let issue: GitHubIssue
```

### `pullRequest`

```swift
public let pullRequest: GitHubPR
```

### `commits`

```swift
public let commits: [GitHubCommit]
```

### `reviews`

```swift
public let reviews: [GitHubReview]
```

### `requestedReviewers`

```swift
public let requestedReviewers: GitHubRequestedReviewers
```

### `api`

```swift
internal(set) public var api: Octokit!
```
