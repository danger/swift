# GitHub.Commit.CommitData

A GitHub specific implementation of a github commit.

``` swift
struct CommitData:​ Equatable, Decodable
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `sha`

The SHA for the commit.

``` swift
let sha:​ String?
```

### `author`

Who wrote the commit.

``` swift
let author:​ Git.Commit.Author
```

### `committer`

Who shipped the code.

``` swift
let committer:​ Git.Commit.Author
```

### `message`

The message for the commit.

``` swift
let message:​ String
```

### `parents`

SHAs for the commit's parents.

``` swift
let parents:​ [String]?
```

### `url`

The URL for the commit.

``` swift
let url:​ String
```
