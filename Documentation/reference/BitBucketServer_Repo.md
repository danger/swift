# BitBucketServer.Repo

``` swift
struct Repo:​ Decodable, Equatable
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `name`

The repo name

``` swift
let name:​ String?
```

### `slug`

The slug for the repo

``` swift
let slug:​ String
```

### `scmId`

The type of SCM tool, probably "git"

``` swift
let scmId:​ String
```

### `isPublic`

Is the repo public?

``` swift
let isPublic:​ Bool
```

### `forkable`

Can someone fork thie repo?

``` swift
let forkable:​ Bool
```

### `project`

An abtraction for grouping repos

``` swift
let project:​ Project
```
