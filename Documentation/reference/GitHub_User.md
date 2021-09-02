# GitHub.User

A GitHub user account.

``` swift
struct User:​ Decodable, Equatable
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `id`

The UUID for the user organization.

``` swift
let id:​ Int
```

### `login`

The handle for the user or organization.

``` swift
let login:​ String
```

### `userType`

The type of user:​ user, organization, or bot.

``` swift
let userType:​ UserType
```
