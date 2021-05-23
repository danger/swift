# BitBucketCloud.Commit

``` swift
public struct Commit: Decodable, Equatable 
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `author`

The author of the commit, assumed to be the person who wrote the code.

``` swift
public let author: Author
```

### `date`

When the commit was commited to the project

``` swift
public let date: Date
```

### `hash`

The SHA for the commit

``` swift
public let hash: String
```

### `message`

The commit's message

``` swift
public let message: String
```
