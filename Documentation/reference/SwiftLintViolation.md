# SwiftLintViolation

``` swift
public struct SwiftLintViolation:​ Decodable
```

## Inheritance

`Decodable`

## Properties

### `ruleID`

``` swift
var ruleID:​ String
```

### `reason`

``` swift
var reason:​ String
```

### `line`

``` swift
var line:​ Int
```

### `severity`

``` swift
var severity:​ Severity
```

### `file`

``` swift
var file:​ String
```

## Methods

### `toMarkdown()`

``` swift
public func toMarkdown() -> String
```
