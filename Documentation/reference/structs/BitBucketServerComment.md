**STRUCT**

# `BitBucketServerComment`

```swift
public struct BitBucketServerComment: Decodable, Equatable
```

## Properties
### `id`

```swift
public let id: Int
```

> The comment's id

### `createdAt`

```swift
public let createdAt: Int
```

> Date comment created as number of mili seconds since the unix epoch

### `user`

```swift
public let user: BitBucketServerUser
```

> The comment's author

### `action`

```swift
public let action: String
```

> The action the user did (e.g. "COMMENTED")

### `fromHash`

```swift
public let fromHash: String?
```

> The SHA to which the comment was created

### `previousFromHash`

```swift
public let previousFromHash: String?
```

> The previous SHA to which the comment was created

### `toHash`

```swift
public let toHash: String?
```

> The next SHA after the comment was created

### `previousToHash`

```swift
public let previousToHash: String?
```

> The SHA to which the comment was created

### `commentAction`

```swift
public let commentAction: String?
```

> Action the user did (e.g. "ADDED") if it is a new task

### `comment`

```swift
public let comment: CommentDetail?
```

> Detailed data of the comment
