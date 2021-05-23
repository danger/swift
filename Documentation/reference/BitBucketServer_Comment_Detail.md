# BitBucketServer.Comment.Detail

``` swift
public struct Detail: Decodable, Equatable 
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `id`

The comment's id

``` swift
public let id: Int
```

### `version`

The comment's version

``` swift
public let version: Int
```

### `text`

The comment content

``` swift
public let text: String
```

### `author`

The author of the comment

``` swift
public let author: User
```

### `createdAt`

Date comment created as number of mili seconds since the unix epoch

``` swift
public let createdAt: Int
```

### `updatedAt`

Date comment updated as number of mili seconds since the unix epoch

``` swift
public let updatedAt: Int
```

### `comments`

Replys to the comment

``` swift
public let comments: [Detail]
```

### `properties`

Properties associated with the comment

``` swift
public let properties: InnerProperties
```

### `tasks`

Tasks associated with the comment

``` swift
public let tasks: [Task]
```
