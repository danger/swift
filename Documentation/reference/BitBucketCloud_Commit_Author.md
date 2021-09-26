# BitBucketCloud.Commit.Author

``` swift
public struct Author:​ Decodable, Equatable
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `raw`

Format:​ `Foo Bar <foo@bar.com>`

``` swift
let raw:​ String
```

### `user`

The user that created the commit

``` swift
let user:​ User?
```
