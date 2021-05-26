# Git

The git specific metadata for a pull request.

``` swift
public struct Git: Decodable, Equatable 
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `modifiedFiles`

Modified filepaths relative to the git root.

``` swift
public let modifiedFiles: [File]
```

### `createdFiles`

Newly created filepaths relative to the git root.

``` swift
public let createdFiles: [File]
```

### `deletedFiles`

Removed filepaths relative to the git root.

``` swift
public let deletedFiles: [File]
```

### `commits`

``` swift
public let commits: [Commit]
```
