**EXTENSION**

# `DangerDSL`

## Properties
### `fails`

```swift
public var fails: [Violation]
```

> Fails on the Danger report

### `warnings`

```swift
public var warnings: [Violation]
```

> Warnings on the Danger report

### `messages`

```swift
public var messages: [Violation]
```

> Messages on the Danger report

### `markdowns`

```swift
public var markdowns: [Violation]
```

> Markdowns on the Danger report

## Methods
### `warn(_:)`

```swift
public func warn(_ message: String)
```

> Adds a warning message to the Danger report
>
> - Parameter message: A markdown-ish

#### Parameters

| Name | Description |
| ---- | ----------- |
| message | A markdown-ish |

### `warn(message:file:line:)`

```swift
public func warn(message: String, file: String, line: Int)
```

> Adds an inline warning message to the Danger report

### `fail(_:)`

```swift
public func fail(_ message: String)
```

> Adds a warning message to the Danger report
>
> - Parameter message: A markdown-ish

#### Parameters

| Name | Description |
| ---- | ----------- |
| message | A markdown-ish |

### `fail(message:file:line:)`

```swift
public func fail(message: String, file: String, line: Int)
```

> Adds an inline fail message to the Danger report

### `message(_:)`

```swift
public func message(_ message: String)
```

> Adds a warning message to the Danger report
>
> - Parameter message: A markdown-ish

#### Parameters

| Name | Description |
| ---- | ----------- |
| message | A markdown-ish |

### `message(message:file:line:)`

```swift
public func message(message: String, file: String, line: Int)
```

> Adds an inline message to the Danger report

### `markdown(_:)`

```swift
public func markdown(_ message: String)
```

> Adds a warning message to the Danger report
>
> - Parameter message: A markdown-ish

#### Parameters

| Name | Description |
| ---- | ----------- |
| message | A markdown-ish |

### `markdown(message:file:line:)`

```swift
public func markdown(message: String, file: String, line: Int)
```

> Adds an inline message to the Danger report

### `suggestion(code:file:line:)`

```swift
public func suggestion(code: String, file: String, line: Int)
```

> Adds an inline suggestion to the Danger report (sends a normal message if suggestions are not supported)
