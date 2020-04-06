# GitHub.Commit

A GitHub specific implementation of a git commit.

``` swift
public struct Commit: Decodable, Equatable
```

## Inheritance

`Decodable`, `Equatable`

## Initializers

### `init(from:)`

``` swift
public init(from decoder: Decoder) throws
```

## Properties

### `sha`

The SHA for the commit.

``` swift
let sha: String
```

### `commit`

The raw commit metadata.

``` swift
let commit: Git.Commit
```

### `url`

The URL for the commit on GitHub.

``` swift
let url: String
```

### `author`

The GitHub user who wrote the code.

``` swift
let author: User?
```

### `committer`

The GitHub user who shipped the code.

``` swift
let committer: User?
```
