# BitBucketServer.PullRequest

``` swift
public struct PullRequest: Decodable, Equatable 
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `id`

The PR's ID

``` swift
public let id: Int
```

### `version`

The API version

``` swift
public let version: Int
```

### `title`

Title of the pull request.

``` swift
public let title: String
```

### `description`

The description of the PR

``` swift
public let description: String?
```

### `state`

The pull request's current status.

``` swift
public let state: String
```

### `open`

Is PR open?

``` swift
public let open: Bool
```

### `closed`

Is PR closed?

``` swift
public let closed: Bool
```

### `createdAt`

Date PR created as number of mili seconds since the unix epoch

``` swift
public let createdAt: Int
```

### `updatedAt`

Date PR updated as number of mili seconds since the unix epoch

``` swift
public let updatedAt: Int?
```

### `fromRef`

The PR submittor's reference

``` swift
public let fromRef: MergeRef
```

### `toRef`

The repo Danger is running on

``` swift
public let toRef: MergeRef
```

### `isLocked`

Is the PR locked?

``` swift
public let isLocked: Bool
```

### `author`

The creator of the PR

``` swift
public let author: Participant
```

### `reviewers`

People requested as reviewers

``` swift
public let reviewers: [Reviewer]
```

### `participants`

People who have participated in the PR

``` swift
public let participants: [Participant]
```
