**STRUCT**

# `GitCommit`

```swift
public struct GitCommit: Decodable, Equatable
```

> A platform agnostic reference to a git commit.

## Properties
### `sha`

```swift
public let sha: String?
```

> The SHA for the commit.

### `author`

```swift
public let author: GitCommitAuthor
```

> Who wrote the commit.

### `committer`

```swift
public let committer: GitCommitAuthor
```

> Who shipped the code.

### `message`

```swift
public let message: String
```

> The message for the commit.

### `parents`

```swift
public let parents: [String]?
```

> SHAs for the commit's parents.

### `url`

```swift
public let url: String
```

> The URL for the commit.
