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
public let github: GitHub!
```

### `bitbucket_server`

```swift
public let bitbucket_server: BitBucketServer!
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