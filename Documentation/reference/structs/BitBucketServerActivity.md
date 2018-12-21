**STRUCT**

# `BitBucketServerActivity`

```swift
public struct BitBucketServerActivity: Decodable, Equatable
```

## Properties
### `id`

```swift
public let id: Int
```

> The activity's ID

### `createdAt`

```swift
public let createdAt: Int
```

> Date activity created as number of mili seconds since the unix epoch

### `user`

```swift
public let user: BitBucketServerUser
```

> The user that triggered the activity.

### `action`

```swift
public let action: String
```

> The action the activity describes (e.g. "COMMENTED").

### `commentAction`

```swift
public let commentAction: String?
```

> In case the action was "COMMENTED" it will state the command specific action (e.g. "CREATED").
