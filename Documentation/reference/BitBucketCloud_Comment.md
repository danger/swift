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
let content: Content
```

### `createdOn`

When the comment was created

``` swift
let createdOn: Date
```

### `deleted`

Was the comment deleted?

``` swift
let deleted: Bool
```

### `id`

``` swift
let id: Int
```

### `inline`

``` swift
let inline: Inline?
```

### `type`

``` swift
let type: String
```

### `updatedOn`

When the comment was updated

``` swift
let updatedOn: Date
```

### `user`

The user that created the comment

``` swift
let user: User
```
