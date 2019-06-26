**STRUCT**

# `GitHubUser`

```swift
public struct GitHubUser: Decodable, Equatable
```

> A GitHub user account.

## Properties
### `id`

```swift
public let id: Int
```

> The UUID for the user organization.

### `login`

```swift
public let login: String
```

> The handle for the user or organization.

### `userType`

```swift
public let userType: UserType
```

> The type of user: user, organization, or bot.
