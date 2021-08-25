# BitBucketServer.Comment.Detail.Task

``` swift
public struct Task:​ Decodable, Equatable
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `id`

The tasks ID

``` swift
let id:​ Int
```

### `createdAt`

Date activity created as number of mili seconds since the unix epoch

``` swift
let createdAt:​ Int
```

### `text`

The text of the task

``` swift
let text:​ String
```

### `state`

The state of the task (e.g. "OPEN")

``` swift
let state:​ String
```

### `author`

The author of the comment

``` swift
let author:​ User
```
