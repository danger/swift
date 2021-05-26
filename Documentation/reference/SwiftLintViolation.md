# SwiftLintViolation

``` swift
public struct SwiftLintViolation: Decodable 
```

## Inheritance

`Decodable`

## Properties

### `ruleID`

``` swift
public internal(set) var ruleID: String
```

### `reason`

``` swift
public internal(set) var reason: String
```

### `line`

``` swift
public internal(set) var line: Int
```

### `severity`

``` swift
public internal(set) var severity: Severity
```

### `file`

``` swift
public internal(set) var file: String
```

## Methods

### `toMarkdown()`

``` swift
public func toMarkdown() -> String 
```
