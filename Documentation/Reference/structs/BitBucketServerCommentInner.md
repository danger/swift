**STRUCT**

# `BitBucketServerCommentInner`

```swift
public struct BitBucketServerCommentInner: Decodable, Equatable
```

## Properties
### `id`

```swift
public let id: Int
```

> The comment's id

### `version`

```swift
public let version: Int
```

> The comment's version

### `text`

```swift
public let text: String
```

> The comment content

### `author`

```swift
public let author: BitBucketServerUser
```

> The author of the comment

### `createdAt`

```swift
public let createdAt: Int
```

> Date comment created as number of mili seconds since the unix epoch

### `updatedAt`

```swift
public let updatedAt: Int
```

> Date comment updated as number of mili seconds since the unix epoch

### `comments`

```swift
public let comments: [BitBucketServerCommentInner]
```

> Replys to the comment

### `properties`

```swift
public let properties: BitBucketServerCommentInnerProperties
```

> Properties associated with the comment

### `tasks`

```swift
public let tasks: [BitBucketServerCommentTask]
```

> Tasks associated with the comment
