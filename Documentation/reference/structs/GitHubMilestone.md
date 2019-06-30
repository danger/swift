**STRUCT**

# `GitHubMilestone`

```swift
public struct GitHubMilestone: Decodable, Equatable
```

## Properties
### `id`

```swift
public let id: Int
```

> The id number of this milestone

### `number`

```swift
public let number: Int
```

> The number of this milestone

### `state`

```swift
public let state: MilestoneState
```

> The state of this milestone: open, closed, all

### `title`

```swift
public let title: String
```

> The title of this milestone

### `description`

```swift
public let description: String?
```

> The description of this milestone.

### `creator`

```swift
public let creator: GitHubUser
```

> The user who created this milestone.

### `openIssues`

```swift
public let openIssues: Int
```

> The number of open issues in this milestone

### `closedIssues`

```swift
public let closedIssues: Int
```

> The number of closed issues in this milestone

### `createdAt`

```swift
public let createdAt: Date
```

> The ISO8601 date string for when this milestone was created.

### `updatedAt`

```swift
public let updatedAt: Date
```

> The ISO8601 date string for when this milestone was updated.

### `closedAt`

```swift
public let closedAt: Date?
```

> The ISO8601 date string for when this milestone was closed.

### `dueOn`

```swift
public let dueOn: Date?
```

> The ISO8601 date string for the due of this milestone.
