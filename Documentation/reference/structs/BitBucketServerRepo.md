**STRUCT**

# `BitBucketServerRepo`

```swift
public struct BitBucketServerRepo: Decodable, Equatable
```

## Properties
### `name`

```swift
public let name: String?
```

> The repo name

### `slug`

```swift
public let slug: String
```

> The slug for the repo

### `scmId`

```swift
public let scmId: String
```

> The type of SCM tool, probably "git"

### `isPublic`

```swift
public let isPublic: Bool
```

> Is the repo public?

### `forkable`

```swift
public let forkable: Bool
```

> Can someone fork thie repo?

### `project`

```swift
public let project: BitBucketServerProject
```

> An abtraction for grouping repos
