**STRUCT**

# `DangerUtils`

> Utility functions that make Dangerfiles easier to write

## Methods
### `readFile(_:)`

> Let's you go from a file path to the contents of the file
> with less hassle.
>
> It specifically assumes golden path code so Dangerfiles
> don't have to include error handlings - an error will
> exit evaluation entirely as it should only happen at dev-time.
>
> - Parameter file: the file reference from git.modified/creasted/deleted etc
> - Returns: the file contents, or bails

### `exec(_:arguments:)`

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

### `spawn(_:arguments:)`

> Gives you the ability to cheaply run a command and read the
> output without having to mess around too much, and exposes
> command errors in a pretty elegant way.
>
> - Parameter command: The first part of the command
> - Parameter arguments: An optional array of arguements to pass in extra
> - Returns: the stdout from the command
