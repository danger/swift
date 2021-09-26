# BitBucketServer.Comment

``` swift
struct Comment:​ Decodable, Equatable
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `id`

The comment's id

``` swift
let id:​ Int
```

### `createdAt`

Date comment created as number of mili seconds since the unix epoch

``` swift
let createdAt:​ Int
```

### `user`

The comment's author

``` swift
let user:​ User
```

### `action`

The action the user did (e.g. "COMMENTED")

``` swift
let action:​ String
```

### `fromHash`

The SHA to which the comment was created

``` swift
let fromHash:​ String?
```

### `previousFromHash`

The previous SHA to which the comment was created

``` swift
let previousFromHash:​ String?
```

### `toHash`

The next SHA after the comment was created

``` swift
let toHash:​ String?
```

### `previousToHash`

The SHA to which the comment was created

``` swift
let previousToHash:​ String?
```

### `commentAction`

Action the user did (e.g. "ADDED") if it is a new task

``` swift
let commentAction:​ String?
```

### `comment`

Detailed data of the comment

``` swift
let comment:​ Detail?
```
