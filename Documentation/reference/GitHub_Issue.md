# GitHub.Issue

``` swift
public struct Issue: Decodable, Equatable 
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `id`

The id number of the issue

``` swift
public let id: Int
```

### `number`

The number of the issue.

``` swift
public let number: Int
```

### `title`

The title of the issue.

``` swift
public let title: String
```

### `user`

The user who created the issue.

``` swift
public let user: User
```

### `state`

The state for the issue:​ open, closed, locked.

``` swift
public let state: State
```

### `isLocked`

A boolean indicating if the issue has been locked to contributors only.

``` swift
public let isLocked: Bool
```

### `body`

The markdown body message of the issue.

``` swift
public let body: String?
```

### `commentCount`

The comment number of comments for the issue.

``` swift
public let commentCount: Int
```

### `assignee`

The user who is assigned to the issue.

``` swift
public let assignee: User?
```

### `assignees`

The users who are assigned to the issue.

``` swift
public let assignees: [User]
```

### `milestone`

The milestone of this issue

``` swift
public let milestone: Milestone?
```

### `createdAt`

The ISO8601 date string for when the issue was created.

``` swift
public let createdAt: Date
```

### `updatedAt`

The ISO8601 date string for when the issue was updated.

``` swift
public let updatedAt: Date
```

### `closedAt`

The ISO8601 date string for when the issue was closed.

``` swift
public let closedAt: Date?
```

### `labels`

The labels associated with this issue.

``` swift
public let labels: [Label]
```
