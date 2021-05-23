# BitBucketServer.Activity

``` swift
public struct Activity: Decodable, Equatable 
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `id`

The activity's ID

``` swift
public let id: Int
```

### `createdAt`

Date activity created as number of mili seconds since the unix epoch

``` swift
public let createdAt: Int
```

### `user`

The user that triggered the activity.

``` swift
public let user: User
```

### `action`

The action the activity describes (e.g. "COMMENTED").

``` swift
public let action: String
```

### `commentAction`

In case the action was "COMMENTED" it will state the command specific action (e.g. "CREATED").

``` swift
public let commentAction: String?
```
