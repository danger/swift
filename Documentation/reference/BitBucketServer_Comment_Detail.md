# BitBucketServer.Comment.Detail

``` swift
public struct Detail:​ Decodable, Equatable
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `id`

The comment's id

``` swift
let id:​ Int
```

### `version`

The comment's version

``` swift
let version:​ Int
```

### `text`

The comment content

``` swift
let text:​ String
```

### `author`

The author of the comment

``` swift
let author:​ User
```

### `createdAt`

Date comment created as number of mili seconds since the unix epoch

``` swift
let createdAt:​ Int
```

### `updatedAt`

Date comment updated as number of mili seconds since the unix epoch

``` swift
let updatedAt:​ Int
```

### `comments`

Replys to the comment

``` swift
let comments:​ [Detail]
```

### `properties`

Properties associated with the comment

``` swift
let properties:​ InnerProperties
```

### `tasks`

Tasks associated with the comment

``` swift
let tasks:​ [Task]
```
