# BitBucketServer.Comment

``` swift
public struct Comment: Decodable, Equatable 
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `id`

The comment's id

``` swift
public let id: Int
```

### `createdAt`

Date comment created as number of mili seconds since the unix epoch

``` swift
public let createdAt: Int
```

### `user`

The comment's author

``` swift
public let user: User
```

### `action`

The action the user did (e.g. "COMMENTED")

``` swift
public let action: String
```

### `fromHash`

The SHA to which the comment was created

``` swift
public let fromHash: String?
```

### `previousFromHash`

The previous SHA to which the comment was created

``` swift
public let previousFromHash: String?
```

### `toHash`

The next SHA after the comment was created

``` swift
public let toHash: String?
```

### `previousToHash`

The SHA to which the comment was created

``` swift
public let previousToHash: String?
```

### `commentAction`

Action the user did (e.g. "ADDED") if it is a new task

``` swift
public let commentAction: String?
```

### `comment`

Detailed data of the comment

``` swift
public let comment: Detail?
```
