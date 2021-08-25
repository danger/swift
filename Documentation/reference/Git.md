# Git

The git specific metadata for a pull request.

``` swift
public struct Git:​ Decodable, Equatable
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `modifiedFiles`

Modified filepaths relative to the git root.

``` swift
let modifiedFiles:​ [File]
```

### `createdFiles`

Newly created filepaths relative to the git root.

``` swift
let createdFiles:​ [File]
```

### `deletedFiles`

Removed filepaths relative to the git root.

``` swift
let deletedFiles:​ [File]
```

### `commits`

``` swift
let commits:​ [Commit]
```
