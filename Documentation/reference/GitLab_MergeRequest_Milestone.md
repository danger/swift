# GitLab.MergeRequest.Milestone

``` swift
public struct Milestone: Decodable, Equatable 
```

## Inheritance

`Decodable`, `Equatable`

## Initializers

### `init(from:)`

``` swift
public init(from decoder: Decoder) throws 
```

## Properties

### `createdAt`

``` swift
public let createdAt: Date
```

### `description`

``` swift
public let description: String
```

### `dueDate`

``` swift
public let dueDate: Date?
```

### `id`

``` swift
public let id: Int
```

### `iid`

``` swift
public let iid: Int
```

### `parent`

An unified identifier for [project milestone](https:​//docs.gitlab.com/ee/api/milestones.html)'s `project_id`  
and [group milestone](https:​//docs.gitlab.com/ee/api/group_milestones.html)'s `group_id`.

``` swift
public let parent: ParentIdentifier
```

### `startDate`

``` swift
public let startDate: Date?
```

### `state`

``` swift
public let state: State
```

### `title`

``` swift
public let title: String
```

### `updatedAt`

``` swift
public let updatedAt: Date
```

### `webUrl`

``` swift
public let webUrl: String
```
