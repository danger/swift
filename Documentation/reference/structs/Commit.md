**STRUCT**

# `Commit`

```swift
public struct Commit: Decodable, Equatable
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
public let commit: Git.Commit
```

> The raw commit metadata.

### `url`

```swift
public let url: String
```

> The URL for the commit on GitHub.

### `author`

```swift
public let author: User?
```

> The GitHub user who wrote the code.

### `committer`

```swift
public let committer: User?
```

> The GitHub user who shipped the code.

## Methods
### `init(from:)`

```swift
public init(from decoder: Decoder) throws
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| decoder | The decoder to read data from. |