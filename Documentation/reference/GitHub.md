# GitHub

The GitHub metadata for your pull request.

``` swift
public struct GitHub:​ Decodable
```

## Inheritance

`Decodable`

## Properties

### `issue`

``` swift
let issue:​ Issue
```

### `pullRequest`

``` swift
let pullRequest:​ PullRequest
```

### `commits`

``` swift
let commits:​ [Commit]
```

### `reviews`

``` swift
let reviews:​ [Review]
```

### `requestedReviewers`

``` swift
let requestedReviewers:​ RequestedReviewers
```

### `api`

``` swift
var api:​ Octokit!
```
