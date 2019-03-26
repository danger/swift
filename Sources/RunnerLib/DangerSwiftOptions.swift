// Options handled directly by Danger swift and not sent back to Danger JS

public enum DangerSwiftOptions: String, CaseIterable {
    case dangerJSPath = "--danger-js-path"

    public var hasParameter: Bool {
        switch self {
        case .dangerJSPath:
            return true
        }
    }
}
