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
let id: Int
```

### `name`

The name of the repo, e.g. "danger-swift".

``` swift
let name: String
```

### `fullName`

The full name of the owner + repo, e.g. "Danger/danger-swift"

``` swift
let fullName: String
```

### `owner`

The owner of the repo.

``` swift
let owner: User
```

### `isPrivate`

A boolean stating whether the repo is publicly accessible.

``` swift
let isPrivate: Bool
```

### `description`

A textual description of the repo.

``` swift
let description: String?
```

### `isFork`

A boolean stating whether the repo is a fork.

``` swift
let isFork: Bool
```

### `htmlURL`

The root web URL for the repo, e.g. https://github.com/artsy/emission

``` swift
let htmlURL: String
```
