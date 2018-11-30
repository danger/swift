**STRUCT**

# `BitBucketServerMergeRef`

```swift
public struct BitBucketServerMergeRef: Decodable, Equatable
```

## Properties
### `id`

```swift
public let id: String
```

> The branch name

### `displayId`

```swift
public let displayId: String
```

> The human readable branch name

### `latestCommit`

```swift
public let latestCommit: String
```

> The SHA for the latest commit

### `repository`

```swift
public let repository: BitBucketServerRepo
```

> Info of the associated repository
