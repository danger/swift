# BitBucketCloud.PullRequest.Participant

``` swift
public struct Participant:​ Decodable, Equatable
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `approved`

Did they approve of the PR?

``` swift
let approved:​ Bool
```

### `role`

How did they contribute

``` swift
let role:​ Role
```

### `user`

The user who participated in this PR

``` swift
let user:​ User
```
