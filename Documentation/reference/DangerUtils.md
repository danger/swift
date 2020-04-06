# DangerUtils

Utility functions that make Dangerfiles easier to write

``` swift
public struct DangerUtils
```

## Methods

### `readFile(_:)`

Let's you go from a file path to the contents of the file
with less hassle.

``` swift
public func readFile(_ file: File) -> String
```

It specifically assumes golden path code so Dangerfiles
don't have to include error handlings - an error will
exit evaluation entirely as it should only happen at dev-time.

#### Parameters

  - file: the file reference from git.modified/creasted/deleted etc

#### Returns

the file contents, or bails

### `lines(for:inFile:)`

Returns the line number of the lines that contain a specific string in a file

``` swift
public func lines(for string: String, inFile file: File) -> [Int]
```

#### Parameters

  - string: The string you want to search
  - file: The file path of the file where you want to search the string

#### Returns

the line number of the lines where the passed string is contained

### `exec(_:arguments:)`

Gives you the ability to cheaply run a command and read the
output without having to mess around

``` swift
public func exec(_ command: String, arguments: [String] = []) -> String
```

It generally assumes that the command will pass, as you only get
a string of the STDOUT. If you think your command could/should fail
then you want to use `spawn` instead.

#### Parameters

  - command: The first part of the command
  - arguments: An optional array of arguements to pass in extra

#### Returns

the stdout from the command

### `spawn(_:arguments:)`

Gives you the ability to cheaply run a command and read the
output without having to mess around too much, and exposes
command errors in a pretty elegant way.

``` swift
public func spawn(_ command: String, arguments: [String] = []) throws -> String
```

#### Parameters

  - command: The first part of the command
  - arguments: An optional array of arguements to pass in extra

#### Returns

the stdout from the command
