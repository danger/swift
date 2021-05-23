# BitBucketServer.User

``` swift
public struct User: Decodable, Equatable 
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `id`

The unique user ID

``` swift
public let id: Int?
```

### `name`

The name of the user

``` swift
public let name: String
```

### `displayName`

The name to use when referencing the user

``` swift
public let displayName: String?
```

### `emailAddress`

The email for the user

``` swift
public let emailAddress: String?
```

### `active`

Is the account active

``` swift
public let active: Bool?
```

### `slug`

The user's slug for URLs

``` swift
public let slug: String?
```

### `type`

The type of a user, "NORMAL" being a typical user3

``` swift
public let type: String?
```
