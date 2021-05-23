# GitHub.User

A GitHub user account.

``` swift
public struct User: Decodable, Equatable 
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `id`

The UUID for the user organization.

``` swift
public let id: Int
```

### `login`

The handle for the user or organization.

``` swift
public let login: String
```

### `userType`

The type of user:​ user, organization, or bot.

``` swift
public let userType: UserType
```
