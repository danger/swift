# BitBucketServer.User

``` swift
struct User:​ Decodable, Equatable
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `id`

The unique user ID

``` swift
let id:​ Int?
```

### `name`

The name of the user

``` swift
let name:​ String
```

### `displayName`

The name to use when referencing the user

``` swift
let displayName:​ String?
```

### `emailAddress`

The email for the user

``` swift
let emailAddress:​ String?
```

### `active`

Is the account active

``` swift
let active:​ Bool?
```

### `slug`

The user's slug for URLs

``` swift
let slug:​ String?
```

### `type`

The type of a user, "NORMAL" being a typical user3

``` swift
let type:​ String?
```
