# BitBucketServer.Activity

``` swift
struct Activity:​ Decodable, Equatable
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `id`

The activity's ID

``` swift
let id:​ Int
```

### `createdAt`

Date activity created as number of mili seconds since the unix epoch

``` swift
let createdAt:​ Int
```

### `user`

The user that triggered the activity.

``` swift
let user:​ User
```

### `action`

The action the activity describes (e.g. "COMMENTED").

``` swift
let action:​ String
```

### `commentAction`

In case the action was "COMMENTED" it will state the command specific action (e.g. "CREATED").

``` swift
let commentAction:​ String?
```
