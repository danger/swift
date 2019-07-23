**STRUCT**

# `MergeRef`

```swift
public struct MergeRef: Decodable, Equatable
```

> Represents 'head' in PR

## Properties
### `label`

```swift
public let label: String
```

> The human display name for the merge reference, e.g. "artsy:master".

### `ref`

```swift
public let ref: String
```

> The reference point for the merge, e.g. "master"

### `sha`

```swift
public let sha: String
```

> The reference point for the merge, e.g. "704dc55988c6996f69b6873c2424be7d1de67bbe"

### `user`

```swift
public let user: User
```

> The user that owns the merge reference e.g. "artsy"

### `repo`

```swift
public let repo: Repo
```

> The repo from which the reference comes from
