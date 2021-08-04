# Git.Commit

A platform agnostic reference to a git commit.

``` swift
struct Commit:​ Equatable
```

## Inheritance

`Equatable`

## Properties

### `sha`

The SHA for the commit.

``` swift
let sha:​ String?
```

### `author`

Who wrote the commit.

``` swift
let author:​ Author
```

### `committer`

Who shipped the code.

``` swift
let committer:​ Author
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
let url:​ String?
```
