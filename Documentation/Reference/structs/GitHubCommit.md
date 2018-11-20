**STRUCT**

# `GitHubCommit`

```swift
public struct GitHubCommit: Decodable, Equatable
```

> A GitHub specific implementation of a git commit.

## Properties
### `sha`

```swift
public let sha: String
```

> The SHA for the commit.

### `commit`

```swift
public let commit: GitCommit
```

> The raw commit metadata.

### `url`

```swift
public let url: String
```

> The URL for the commit on GitHub.

### `author`

```swift
public let author: GitHubUser?
```

> The GitHub user who wrote the code.

### `committer`

```swift
public let committer: GitHubUser?
```

> The GitHub user who shipped the code.
