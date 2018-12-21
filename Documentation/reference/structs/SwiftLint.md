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
                        swiftlintPath: String = "swiftlint") -> [SwiftLintViolation]
```

> This is the main entry point for linting Swift in PRs.
