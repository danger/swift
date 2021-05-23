# GitHub.MergeRef

Represents 'head' in PR

``` swift
public struct MergeRef: Decodable, Equatable 
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `label`

The human display name for the merge reference, e.g. "artsy:​master".

``` swift
public let label: String
```

### `ref`

The reference point for the merge, e.g. "master"

``` swift
public let ref: String
```

### `sha`

The reference point for the merge, e.g. "704dc55988c6996f69b6873c2424be7d1de67bbe"

``` swift
public let sha: String
```

### `user`

The user that owns the merge reference e.g. "artsy"

``` swift
public let user: User
```

### `repo`

The repo from which the reference comes from

``` swift
public let repo: Repo
```
