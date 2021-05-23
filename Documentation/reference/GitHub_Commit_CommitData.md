# GitHub.Commit.CommitData

A GitHub specific implementation of a github commit.

``` swift
public struct CommitData: Equatable, Decodable 
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `sha`

The SHA for the commit.

``` swift
public let sha: String?
```

### `author`

Who wrote the commit.

``` swift
public let author: Git.Commit.Author
```

### `committer`

Who shipped the code.

``` swift
public let committer: Git.Commit.Author
```

### `message`

The message for the commit.

``` swift
public let message: String
```

### `parents`

SHAs for the commit's parents.

``` swift
public let parents: [String]?
```

### `url`

The URL for the commit.

``` swift
public let url: String
```
