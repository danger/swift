# BitBucketCloud.PullRequest.Participant

``` swift
public struct Participant: Decodable, Equatable 
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `approved`

Did they approve of the PR?

``` swift
public let approved: Bool
```

### `role`

How did they contribute

``` swift
public let role: Role
```

### `user`

The user who participated in this PR

``` swift
public let user: User
```
