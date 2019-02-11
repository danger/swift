**STRUCT**

# `BitBucketServerUser`

```swift
public struct BitBucketServerUser: Decodable, Equatable
```

## Properties
### `id`

```swift
public let id: Int?
```

> The unique user ID

### `name`

```swift
public let name: String
```

> The name of the user

### `displayName`

```swift
public let displayName: String?
```

> The name to use when referencing the user

### `emailAddress`

```swift
public let emailAddress: String
```

> The email for the user

### `active`

```swift
public let active: Bool?
```

> Is the account active

### `slug`

```swift
public let slug: String?
```

> The user's slug for URLs

### `type`

```swift
public let type: String?
```

> The type of a user, "NORMAL" being a typical user3
