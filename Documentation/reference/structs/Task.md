**STRUCT**

# `Task`

```swift
public struct Task: Decodable, Equatable
```

## Properties
### `id`

```swift
public let id: Int
```

> The tasks ID

### `createdAt`

```swift
public let createdAt: Int
```

> Date activity created as number of mili seconds since the unix epoch

### `text`

```swift
public let text: String
```

> The text of the task

### `state`

```swift
public let state: String
```

> The state of the task (e.g. "OPEN")

### `author`

```swift
public let author: User
```

> The author of the comment
