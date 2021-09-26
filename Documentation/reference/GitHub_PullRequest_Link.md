# GitHub.PullRequest.Link

Pull Requests have possible link relations

``` swift
struct Link:​ Decodable, Equatable
```

  - See:​
    [Reference](https:​//docs.github.com/en/rest/reference/pulls#link-relations)

## Inheritance

`Decodable`, `Equatable`

## Properties

### `` `self` ``

The API location of the Pull Request.

``` swift
let `self`:​ Relation
```

### `html`

The HTML location of the Pull Request.

``` swift
let html:​ Relation
```

### `issue`

The API location of the Pull Request's Issue.

``` swift
let issue:​ Relation
```

### `comments`

The API location of the Pull Request's Issue comments.

``` swift
let comments:​ Relation
```

### `reviewComments`

The API location of the Pull Request's Review comments.

``` swift
let reviewComments:​ Relation
```

### `reviewComment`

The URL template to construct the API location for a Review comment in the Pull Request's repository.

``` swift
let reviewComment:​ Relation
```

### `commits`

The API location of the Pull Request's commits.

``` swift
let commits:​ Relation
```

### `statuses`

The API location of the Pull Request's commit statuses, which are the statuses of its head branch.

``` swift
let statuses:​ Relation
```
