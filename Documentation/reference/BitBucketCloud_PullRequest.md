# BitBucketCloud.PullRequest

``` swift
public struct PullRequest: Decodable 
```

## Inheritance

`Decodable`

## Properties

### `author`

The creator of the PR

``` swift
public let author: User
```

### `createdOn`

Date when PR was created

``` swift
public let createdOn: Date
```

### `description`

The text describing the PR

``` swift
public let description: String
```

### `destination`

The PR's destination

``` swift
public let destination: MergeRef
```

### `id`

PR's ID

``` swift
public let id: Int
```

### `participants`

People who have participated in the PR

``` swift
public let participants: [Participant]
```

### `reviewers`

People requested as reviewers

``` swift
public let reviewers: [User]
```

### `source`

The PR's source, The repo Danger is running on

``` swift
public let source: MergeRef
```

### `state`

The pull request's current status.

``` swift
public let state: State
```

### `title`

Title of the pull request

``` swift
public let title: String
```

### `updatedOn`

Date of last update

``` swift
public let updatedOn: Date
```
