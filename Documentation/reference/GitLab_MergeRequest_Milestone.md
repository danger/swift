# GitLab.MergeRequest.Milestone

``` swift
public struct Milestone:​ Decodable, Equatable
```

## Inheritance

`Decodable`, `Equatable`

## Initializers

### `init(from:​)`

``` swift
init(from decoder:​ Decoder) throws
```

## Properties

### `createdAt`

``` swift
let createdAt:​ Date
```

### `description`

``` swift
let description:​ String
```

### `dueDate`

``` swift
let dueDate:​ Date?
```

### `id`

``` swift
let id:​ Int
```

### `iid`

``` swift
let iid:​ Int
```

### `parent`

An unified identifier for [project milestone](https:​//docs.gitlab.com/ee/api/milestones.html)'s `project_id`  
and [group milestone](https:​//docs.gitlab.com/ee/api/group_milestones.html)'s `group_id`.

``` swift
let parent:​ ParentIdentifier
```

### `startDate`

``` swift
let startDate:​ Date?
```

### `state`

``` swift
let state:​ State
```

### `title`

``` swift
let title:​ String
```

### `updatedAt`

``` swift
let updatedAt:​ Date
```

### `webUrl`

``` swift
let webUrl:​ String
```
