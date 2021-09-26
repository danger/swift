# GitHub.Milestone

``` swift
struct Milestone:​ Decodable, Equatable
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `id`

The id number of this milestone

``` swift
let id:​ Int
```

### `number`

The number of this milestone

``` swift
let number:​ Int
```

### `state`

The state of this milestone:​ open, closed, all

``` swift
let state:​ State
```

### `title`

The title of this milestone

``` swift
let title:​ String
```

### `description`

The description of this milestone.

``` swift
let description:​ String?
```

### `creator`

The user who created this milestone.

``` swift
let creator:​ User
```

### `openIssues`

The number of open issues in this milestone

``` swift
let openIssues:​ Int
```

### `closedIssues`

The number of closed issues in this milestone

``` swift
let closedIssues:​ Int
```

### `createdAt`

The ISO8601 date string for when this milestone was created.

``` swift
let createdAt:​ Date
```

### `updatedAt`

The ISO8601 date string for when this milestone was updated.

``` swift
let updatedAt:​ Date
```

### `closedAt`

The ISO8601 date string for when this milestone was closed.

``` swift
let closedAt:​ Date?
```

### `dueOn`

The ISO8601 date string for the due of this milestone.

``` swift
let dueOn:​ Date?
```
