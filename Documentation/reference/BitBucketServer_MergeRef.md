# BitBucketServer.MergeRef

``` swift
public struct MergeRef: Decodable, Equatable 
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `id`

The branch name

``` swift
public let id: String
```

### `displayId`

The human readable branch name

``` swift
public let displayId: String
```

### `latestCommit`

The SHA for the latest commit

``` swift
public let latestCommit: String
```

### `repository`

Info of the associated repository

``` swift
public let repository: Repo
```
