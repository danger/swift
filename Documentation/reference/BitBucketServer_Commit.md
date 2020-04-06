# BitBucketServer.Commit

``` swift
public struct Commit: Decodable, Equatable
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `id`

The SHA for the commit

``` swift
let id: String
```

### `displayId`

The shortened SHA for the commit

``` swift
let displayId: String
```

### `author`

The author of the commit, assumed to be the person who wrote the code.

``` swift
let author: User
```

### `authorTimestamp`

The UNIX timestamp for when the commit was authored

``` swift
let authorTimestamp: Int
```

### `committer`

The author of the commit, assumed to be the person who commited/merged the code into a project.

``` swift
let committer: User?
```

### `committerTimestamp`

When the commit was commited to the project

``` swift
let committerTimestamp: Int?
```

### `message`

The commit's message

``` swift
let message: String
```

### `parents`

The commit's parents

``` swift
let parents: [Parent]
```
