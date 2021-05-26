# BitBucketServer.Repo

``` swift
public struct Repo: Decodable, Equatable 
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `name`

The repo name

``` swift
public let name: String?
```

### `slug`

The slug for the repo

``` swift
public let slug: String
```

### `scmId`

The type of SCM tool, probably "git"

``` swift
public let scmId: String
```

### `isPublic`

Is the repo public?

``` swift
public let isPublic: Bool
```

### `forkable`

Can someone fork thie repo?

``` swift
public let forkable: Bool
```

### `project`

An abtraction for grouping repos

``` swift
public let project: Project
```
