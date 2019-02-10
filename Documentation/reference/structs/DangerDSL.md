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
private(set) public var github: GitHub!
```

### `bitbucketServer`

```swift
public let bitbucketServer: BitBucketServer!
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