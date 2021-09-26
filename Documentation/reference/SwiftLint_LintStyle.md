# SwiftLint.LintStyle

``` swift
public enum LintStyle
```

## Enumeration Cases

### `all`

Lints all the files instead of only the modified and created files.

``` swift
case all(directory:​ String?)
```

#### Parameters

  - directory:​ - directory:​ Optional property to set the --path to execute at.

### `modifiedAndCreatedFiles`

Only lints the modified and created files with `.swift` extension.

``` swift
case modifiedAndCreatedFiles(directory:​ String?)
```

#### Parameters

  - directory:​ - directory:​ Optional property to set the --path to execute at.

### `files`

Lints only the given files. This can be useful to do some manual filtering.
The files will be filtered on `.swift` only.

``` swift
case files(:​ [File])
```
