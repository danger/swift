**STRUCT**

# `DangerUtils`

```swift
public struct DangerUtils
```

> Utility functions that make Dangerfiles easier to write

## Methods
### `readFile(_:)`

```swift
public func readFile(_ file: File) -> String
```

> Let's you go from a file path to the contents of the file
> with less hassle.
> Tt specifically assumes golden path code so Dangerfiles
> don't have to include error handlings - an error will
> exit evaluation entirely as it should only happen at dev-time.
>
> - Parameter file: the file reference from git.modified/creasted/deleted etc
> - Returns: the file contents, or bails

#### Parameters

| Name | Description |
| ---- | ----------- |
| file | the file reference from git.modified/creasted/deleted etc |