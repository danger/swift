# Git.Commit

A platform agnostic reference to a git commit.

``` swift
public struct Commit: Equatable 
```

## Inheritance

`Equatable`

## Properties

### `sha`

The SHA for the commit.

``` swift
public let sha: String?
```

### `author`

Who wrote the commit.

``` swift
public let author: Author
```

### `committer`

Who shipped the code.

``` swift
public let committer: Author
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
public let url: String?
```
