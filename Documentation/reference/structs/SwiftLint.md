**STRUCT**

# `SwiftLint`

```swift
public struct SwiftLint
```

> The SwiftLint plugin has been embedded inside Danger, making
> it usable out of the box.

## Methods
### `lint(inline:directory:configFile:lintAllFiles:swiftlintPath:)`

```swift
public static func lint(inline: Bool = false, directory: String? = nil,
                        configFile: String? = nil, lintAllFiles: Bool = false,
                        swiftlintPath: String? = nil) -> [SwiftLintViolation]
```

> This is the main entry point for linting Swift in PRs.
>
> When the swiftlintPath is not specified,
> it uses by default swift run swiftlint if the Package.swift contains swiftlint as dependency,
> otherwise calls directly the swiftlint command
