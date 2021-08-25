# BitBucketServer.MergeRef

``` swift
struct MergeRef:​ Decodable, Equatable
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `id`

The branch name

``` swift
let id:​ String
```

### `displayId`

The human readable branch name

``` swift
let displayId:​ String
```

### `latestCommit`

The SHA for the latest commit

``` swift
let latestCommit:​ String
```

### `repository`

Info of the associated repository

``` swift
let repository:​ Repo
```
