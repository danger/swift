# SwiftLint

The SwiftLint plugin has been embedded inside Danger, making
it usable out of the box.

``` swift
public enum SwiftLint
```

## Methods

### `lint(inline:directory:configFile:strict:quiet:lintAllFiles:swiftlintPath:)`

This method is deprecated in favor of

``` swift
@available(*, deprecated, message: "Use the lint(_ lintStyle ..) method instead.") @discardableResult public static func lint(inline: Bool = false, directory: String? = nil, configFile: String? = nil, strict: Bool = false, quiet: Bool = true, lintAllFiles: Bool = false, swiftlintPath: String? = nil) -> [SwiftLintViolation]
```

### `lint(_:inline:configFile:strict:quiet:swiftlintPath:)`

This is the main entry point for linting Swift in PRs.

``` swift
@discardableResult public static func lint(_ lintStyle: LintStyle = .modifiedAndCreatedFiles(directory: nil), inline: Bool = false, configFile: String? = nil, strict: Bool = false, quiet: Bool = true, swiftlintPath: String? = nil) -> [SwiftLintViolation]
```

When the swiftlintPath is not specified,
it uses by default swift run swiftlint if the Package.swift contains swiftlint as dependency,
otherwise calls directly the swiftlint command
