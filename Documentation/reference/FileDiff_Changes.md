# FileDiff.Changes

``` swift
public enum Changes: Equatable 
```

## Inheritance

`Equatable`

## Enumeration Cases

### `created`

``` swift
case created(addedLines: [String])
```

### `deleted`

``` swift
case deleted(deletedLines: [String])
```

### `modified`

``` swift
case modified(hunks: [Hunk])
```

### `renamed`

``` swift
case renamed(oldPath: String, hunks: [Hunk])
```
