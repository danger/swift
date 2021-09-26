# BitBucketServer.PullRequest

``` swift
struct PullRequest:​ Decodable, Equatable
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `id`

The PR's ID

``` swift
let id:​ Int
```

### `version`

The API version

``` swift
let version:​ Int
```

### `title`

Title of the pull request.

``` swift
let title:​ String
```

### `description`

The description of the PR

``` swift
let description:​ String?
```

### `state`

The pull request's current status.

``` swift
let state:​ String
```

### `open`

Is PR open?

``` swift
let open:​ Bool
```

### `closed`

Is PR closed?

``` swift
let closed:​ Bool
```

### `createdAt`

Date PR created as number of mili seconds since the unix epoch

``` swift
let createdAt:​ Int
```

### `updatedAt`

Date PR updated as number of mili seconds since the unix epoch

``` swift
let updatedAt:​ Int?
```

### `fromRef`

The PR submittor's reference

``` swift
let fromRef:​ MergeRef
```

### `toRef`

The repo Danger is running on

``` swift
let toRef:​ MergeRef
```

### `isLocked`

Is the PR locked?

``` swift
let isLocked:​ Bool
```

### `author`

The creator of the PR

``` swift
let author:​ Participant
```

### `reviewers`

People requested as reviewers

``` swift
let reviewers:​ [Reviewer]
```

### `participants`

People who have participated in the PR

``` swift
let participants:​ [Participant]
```
