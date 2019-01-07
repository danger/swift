**STRUCT**

# `BitBucketServerCommit`

```swift
public struct BitBucketServerCommit: Decodable, Equatable
```

## Properties
### `id`

```swift
public let id: String
```

> The SHA for the commit

### `displayId`

```swift
public let displayId: String
```

> The shortened SHA for the commit

### `author`

```swift
public let author: BitBucketServerUser
```

> The author of the commit, assumed to be the person who wrote the code.

### `authorTimestamp`

```swift
public let authorTimestamp: Int
```

> The UNIX timestamp for when the commit was authored

### `committer`

```swift
public let committer: BitBucketServerUser?
```

> The author of the commit, assumed to be the person who commited/merged the code into a project.

### `committerTimestamp`

```swift
public let committerTimestamp: Int?
```

> When the commit was commited to the project

### `message`

```swift
public let message: String
```

> The commit's message

### `parents`

```swift
public let parents: [BitBucketServerCommitParent]
```

> The commit's parents
