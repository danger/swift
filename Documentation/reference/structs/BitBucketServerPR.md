**STRUCT**

# `BitBucketServerPR`

```swift
public struct BitBucketServerPR: Decodable, Equatable
```

## Properties
### `id`

```swift
public let id: Int
```

> The PR's ID

### `version`

```swift
public let version: Int
```

> The API version

### `title`

```swift
public let title: String
```

> Title of the pull request.

### `description`

```swift
public let description: String?
```

> The description of the PR

### `state`

```swift
public let state: String
```

> The pull request's current status.

### `open`

```swift
public let open: Bool
```

> Is PR open?

### `closed`

```swift
public let closed: Bool
```

> Is PR closed?

### `createdAt`

```swift
public let createdAt: Int
```

> Date PR created as number of mili seconds since the unix epoch

### `updatedAt`

```swift
public let updatedAt: Int?
```

> Date PR updated as number of mili seconds since the unix epoch

### `fromRef`

```swift
public let fromRef: BitBucketServerMergeRef
```

> The PR submittor's reference

### `toRef`

```swift
public let toRef: BitBucketServerMergeRef
```

> The repo Danger is running on

### `isLocked`

```swift
public let isLocked: Bool
```

> Is the PR locked?

### `author`

```swift
public let author: Participant
```

> The creator of the PR

### `reviewers`

```swift
public let reviewers: [Reviewer]
```

> People requested as reviewers

### `participants`

```swift
public let participants: [Participant]
```

> People who have participated in the PR
