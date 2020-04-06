# DangerDSL

``` swift
public struct DangerDSL: Decodable
```

## Inheritance

`Decodable`

## Initializers

### `init(from:)`

``` swift
public init(from decoder: Decoder) throws
```

## Properties

### `git`

``` swift
let git: Git
```

### `github`

``` swift
var github: GitHub!
```

### `bitbucketCloud`

``` swift
let bitbucketCloud: BitBucketCloud!
```

### `bitbucketServer`

``` swift
let bitbucketServer: BitBucketServer!
```

### `gitLab`

``` swift
let gitLab: GitLab!
```

### `utils`

``` swift
let utils: DangerUtils
```

### `fails`

Fails on the Danger report

``` swift
var fails: [Violation]
```

### `warnings`

Warnings on the Danger report

``` swift
var warnings: [Violation]
```

### `messages`

Messages on the Danger report

``` swift
var messages: [Violation]
```

### `markdowns`

Markdowns on the Danger report

``` swift
var markdowns: [Violation]
```

## Methods

### `warn(_:)`

Adds a warning message to the Danger report

``` swift
public func warn(_ message: String)
```

#### Parameters

  - message: A markdown-ish

### `warn(message:file:line:)`

Adds an inline warning message to the Danger report

``` swift
public func warn(message: String, file: String, line: Int)
```

### `fail(_:)`

Adds a warning message to the Danger report

``` swift
public func fail(_ message: String)
```

#### Parameters

  - message: A markdown-ish

### `fail(message:file:line:)`

Adds an inline fail message to the Danger report

``` swift
public func fail(message: String, file: String, line: Int)
```

### `message(_:)`

Adds a warning message to the Danger report

``` swift
public func message(_ message: String)
```

#### Parameters

  - message: A markdown-ish

### `message(message:file:line:)`

Adds an inline message to the Danger report

``` swift
public func message(message: String, file: String, line: Int)
```

### `markdown(_:)`

Adds a warning message to the Danger report

``` swift
public func markdown(_ message: String)
```

#### Parameters

  - message: A markdown-ish

### `markdown(message:file:line:)`

Adds an inline message to the Danger report

``` swift
public func markdown(message: String, file: String, line: Int)
```

### `suggestion(code:file:line:)`

Adds an inline suggestion to the Danger report (sends a normal message if suggestions are not supported)

``` swift
public func suggestion(code: String, file: String, line: Int)
```
