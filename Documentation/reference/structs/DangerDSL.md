**STRUCT**

# `DangerDSL`

```swift
public struct DangerDSL: Decodable
```

## Properties
### `git`

```swift
public let git: Git
```

### `github`

```swift
public private(set) var github: GitHub!
```

### `bitbucketServer`

```swift
public let bitbucketServer: BitBucketServer!
```

### `gitLab`

```swift
public let gitLab: GitLab!
```

### `utils`

```swift
public let utils: DangerUtils
```

## Methods
### `init(from:)`

```swift
public init(from decoder: Decoder) throws
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| decoder | The decoder to read data from. |