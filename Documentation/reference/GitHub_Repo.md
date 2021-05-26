# GitHub.Repo

``` swift
public struct Repo: Decodable, Equatable 
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `id`

Generic UUID.

``` swift
public let id: Int
```

### `name`

The name of the repo, e.g. "danger-swift".

``` swift
public let name: String
```

### `fullName`

The full name of the owner + repo, e.g. "Danger/danger-swift"

``` swift
public let fullName: String
```

### `owner`

The owner of the repo.

``` swift
public let owner: User
```

### `isPrivate`

A boolean stating whether the repo is publicly accessible.

``` swift
public let isPrivate: Bool
```

### `description`

A textual description of the repo.

``` swift
public let description: String?
```

### `isFork`

A boolean stating whether the repo is a fork.

``` swift
public let isFork: Bool
```

### `htmlURL`

The root web URL for the repo, e.g. https:​//github.com/artsy/emission

``` swift
public let htmlURL: String
```
