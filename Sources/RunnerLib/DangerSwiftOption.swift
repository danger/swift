// Options handled directly by Danger swift and not sent back to Danger JS

public enum DangerSwiftOption: String, CaseIterable {
    case dangerJSPath = "--danger-js-path"

    public var hasParameter: Bool {
        switch self {
        case .dangerJSPath:
            return true
        }
    }
}

public enum DangeSwiftRunnerOption: String, CaseIterable {
    case cwd = "--cwd"

    public var hasParameter: Bool {
        switch self {
        case .cwd:
            return true
        }
    }
}
