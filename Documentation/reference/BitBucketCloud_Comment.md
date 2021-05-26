# BitBucketCloud.Comment

``` swift
public struct Comment: Decodable, Equatable 
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `content`

Content of the comment

``` swift
public let content: Content
```

### `createdOn`

When the comment was created

``` swift
public let createdOn: Date
```

### `deleted`

Was the comment deleted?

``` swift
public let deleted: Bool
```

### `id`

``` swift
public let id: Int
```

### `inline`

``` swift
public let inline: Inline?
```

### `type`

``` swift
public let type: String
```

### `updatedOn`

When the comment was updated

``` swift
public let updatedOn: Date
```

### `user`

The user that created the comment

``` swift
public let user: User
```
