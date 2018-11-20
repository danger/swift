**EXTENSION**

# `DangerDSL`

## Properties
### `fails`

> Fails on the Danger report

### `warnings`

> Warnings on the Danger report

### `messages`

> Messages on the Danger report

### `markdowns`

> Markdowns on the Danger report

## Methods
### `warn(_:)`

> Adds a warning message to the Danger report
>
> - Parameter message: A markdown-ish

### `warn(message:file:line:)`

> Adds an inline warning message to the Danger report

### `fail(_:)`

> Adds a warning message to the Danger report
>
> - Parameter message: A markdown-ish

### `fail(message:file:line:)`

> Adds an inline fail message to the Danger report

### `message(_:)`

> Adds a warning message to the Danger report
>
> - Parameter message: A markdown-ish

### `message(message:file:line:)`

> Adds an inline message to the Danger report

### `markdown(_:)`

> Adds a warning message to the Danger report
>
> - Parameter message: A markdown-ish

### `markdown(message:file:line:)`

> Adds an inline message to the Danger report

### `suggestion(code:file:line:)`

> Adds an inline suggestion to the Danger report (sends a normal message if suggestions are not supported)
