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
>
> It specifically assumes golden path code so Dangerfiles
> don't have to include error handlings - an error will
> exit evaluation entirely as it should only happen at dev-time.
>
> - Parameter file: the file reference from git.modified/creasted/deleted etc
> - Returns: the file contents, or bails

#### Parameters

| Name | Description |
| ---- | ----------- |
| file | the file reference from git.modified/creasted/deleted etc |

### `lines(for:inFile:)`

```swift
public func lines(for string: String, inFile file: File) -> [Int]
```

> Returns the line number of the lines that contain a specific string in a file
>
> - Parameter string: The string you want to search
> - Parameter file: The file path of the file where you want to search the string
> - Returns: the line number of the lines where the passed string is contained

#### Parameters

| Name | Description |
| ---- | ----------- |
| string | The string you want to search |
| file | The file path of the file where you want to search the string |

### `exec(_:arguments:)`

```swift
public func exec(_ command: String, arguments: [String] = []) -> String
```

> Gives you the ability to cheaply run a command and read the
> output without having to mess around
>
> It generally assumes that the command will pass, as you only get
> a string of the STDOUT. If you think your command could/should fail
> then you want to use `spawn` instead.
>
> - Parameter command: The first part of the command
> - Parameter arguments: An optional array of arguements to pass in extra
> - Returns: the stdout from the command

#### Parameters

| Name | Description |
| ---- | ----------- |
| command | The first part of the command |
| arguments | An optional array of arguements to pass in extra |

### `spawn(_:arguments:)`

```swift
public func spawn(_ command: String, arguments: [String] = []) throws -> String
```

> Gives you the ability to cheaply run a command and read the
> output without having to mess around too much, and exposes
> command errors in a pretty elegant way.
>
> - Parameter command: The first part of the command
> - Parameter arguments: An optional array of arguements to pass in extra
> - Returns: the stdout from the command

#### Parameters

| Name | Description |
| ---- | ----------- |
| command | The first part of the command |
| arguments | An optional array of arguements to pass in extra |