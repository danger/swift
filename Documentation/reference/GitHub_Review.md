# GitHub.Review

``` swift
public struct Review: Decodable, Equatable
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `body`

The body of the review (if a review was made).

``` swift
let body: String?
```

### `commitId`

The commit ID the review was made on (if a review was made).

``` swift
let commitId: String?
```

### `id`

The id for the review (if a review was made).

``` swift
let id: Int?
```

### `state`

The state of the review (if a review was made).

``` swift
let state: State?
```

### `submittedAt`

The date when the review was submitted

``` swift
let submittedAt: Date
```

### `user`

The user who has completed the review or has been requested to review.

``` swift
let user: User
```
