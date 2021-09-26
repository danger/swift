# BitBucketCloud.PullRequest

``` swift
struct PullRequest:​ Decodable
```

## Inheritance

`Decodable`

## Properties

### `author`

The creator of the PR

``` swift
let author:​ User
```

### `createdOn`

Date when PR was created

``` swift
let createdOn:​ Date
```

### `description`

The text describing the PR

``` swift
let description:​ String
```

### `destination`

The PR's destination

``` swift
let destination:​ MergeRef
```

### `id`

PR's ID

``` swift
let id:​ Int
```

### `participants`

People who have participated in the PR

``` swift
let participants:​ [Participant]
```

### `reviewers`

People requested as reviewers

``` swift
let reviewers:​ [User]
```

### `source`

The PR's source, The repo Danger is running on

``` swift
let source:​ MergeRef
```

### `state`

The pull request's current status.

``` swift
let state:​ State
```

### `title`

Title of the pull request

``` swift
let title:​ String
```

### `updatedOn`

Date of last update

``` swift
let updatedOn:​ Date
```
