# DangerUtils.Environment

``` swift
@dynamicMemberLookup struct Environment
```

## Initializers

### `init(env:​)`

``` swift
init(env:​ @escaping () -> [String:​ String] = { ProcessInfo.processInfo.environment })
```

## Properties

### `env`

``` swift
let env:​ () -> [String:​ String]
```
