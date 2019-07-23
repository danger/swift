**STRUCT**

# `Repo`

```swift
public struct Repo: Decodable, Equatable
```

## Properties
### `id`

```swift
public let id: Int // swiftlint:disable:this identifier_name
```

> Generic UUID.

### `name`

```swift
public let name: String
```

> The name of the repo, e.g. "danger-swift".

### `fullName`

```swift
public let fullName: String
```

> The full name of the owner + repo, e.g. "Danger/danger-swift"

### `owner`

```swift
public let owner: User
```

> The owner of the repo.

### `isPrivate`

```swift
public let isPrivate: Bool
```

> A boolean stating whether the repo is publicly accessible.

### `description`

```swift
public let description: String?
```

> A textual description of the repo.

### `isFork`

```swift
public let isFork: Bool
```

> A boolean stating whether the repo is a fork.

### `htmlURL`

```swift
public let htmlURL: String
```

> The root web URL for the repo, e.g. https://github.com/artsy/emission
