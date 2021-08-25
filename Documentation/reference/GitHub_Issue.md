# GitHub.Issue

``` swift
struct Issue:​ Decodable, Equatable
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `id`

The id number of the issue

``` swift
let id:​ Int
```

### `number`

The number of the issue.

``` swift
let number:​ Int
```

### `title`

The title of the issue.

``` swift
let title:​ String
```

### `user`

The user who created the issue.

``` swift
let user:​ User
```

### `state`

The state for the issue:​ open, closed, locked.

``` swift
let state:​ State
```

### `isLocked`

A boolean indicating if the issue has been locked to contributors only.

``` swift
let isLocked:​ Bool
```

### `body`

The markdown body message of the issue.

``` swift
let body:​ String?
```

### `commentCount`

The comment number of comments for the issue.

``` swift
let commentCount:​ Int
```

### `assignee`

The user who is assigned to the issue.

``` swift
let assignee:​ User?
```

### `assignees`

The users who are assigned to the issue.

``` swift
let assignees:​ [User]
```

### `milestone`

The milestone of this issue

``` swift
let milestone:​ Milestone?
```

### `createdAt`

The ISO8601 date string for when the issue was created.

``` swift
let createdAt:​ Date
```

### `updatedAt`

The ISO8601 date string for when the issue was updated.

``` swift
let updatedAt:​ Date
```

### `closedAt`

The ISO8601 date string for when the issue was closed.

``` swift
let closedAt:​ Date?
```

### `labels`

The labels associated with this issue.

``` swift
let labels:​ [Label]
```
