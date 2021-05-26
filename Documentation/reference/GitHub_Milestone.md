# GitHub.Milestone

``` swift
public struct Milestone: Decodable, Equatable 
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `id`

The id number of this milestone

``` swift
public let id: Int
```

### `number`

The number of this milestone

``` swift
public let number: Int
```

### `state`

The state of this milestone:​ open, closed, all

``` swift
public let state: State
```

### `title`

The title of this milestone

``` swift
public let title: String
```

### `description`

The description of this milestone.

``` swift
public let description: String?
```

### `creator`

The user who created this milestone.

``` swift
public let creator: User
```

### `openIssues`

The number of open issues in this milestone

``` swift
public let openIssues: Int
```

### `closedIssues`

The number of closed issues in this milestone

``` swift
public let closedIssues: Int
```

### `createdAt`

The ISO8601 date string for when this milestone was created.

``` swift
public let createdAt: Date
```

### `updatedAt`

The ISO8601 date string for when this milestone was updated.

``` swift
public let updatedAt: Date
```

### `closedAt`

The ISO8601 date string for when this milestone was closed.

``` swift
public let closedAt: Date?
```

### `dueOn`

The ISO8601 date string for the due of this milestone.

``` swift
public let dueOn: Date?
```
