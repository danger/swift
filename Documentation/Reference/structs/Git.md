**STRUCT**

# `Git`

```swift
public struct Git: Decodable, Equatable
```

> The git specific metadata for a pull request.

## Properties
### `modifiedFiles`

```swift
public let modifiedFiles: [File]
```

> Modified filepaths relative to the git root.

### `createdFiles`

```swift
public let createdFiles: [File]
```

> Newly created filepaths relative to the git root.

### `deletedFiles`

```swift
public let deletedFiles: [File]
```

> Removed filepaths relative to the git root.
