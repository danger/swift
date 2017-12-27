import Foundation

public struct Logger {

    private enum Colors: String {
        case `default` = "\u{001B}[0;0m"
        case red = "\u{001B}[31m"
        case yellow = "\u{001B}[33m"
    }

    public let isVerbose: Bool
    public let isSilent: Bool

    public init(isVerbose: Bool = false, isSilent: Bool = false) {
        self.isVerbose = isVerbose
        self.isSilent = isSilent
    }

    public func logInfo(_ items: Any..., separator: String = " ", terminator: String = "\n", isVerbose: Bool = false) {
        let message = items.joinedDescription(separator: separator)
        print(message, terminator: terminator, isVerbose: isVerbose)
    }

    public func logWarning(_ items: Any..., separator: String = " ", terminator: String = "\n", isVerbose: Bool = false) {
        let yellowWarning = Colors.yellow.rawValue + "WARNING:"
        let message = yellowWarning + " " + items.joinedDescription(separator: separator)
        Swift.print(message, terminator: terminator)
    }

    public func logError(_ items: Any..., separator: String = " ", terminator: String = "\n", isVerbose: Bool = false) {
        let redError = Colors.red.rawValue + "ERROR:"
        let message = redError + " " + items.joinedDescription(separator: separator)
        print(message, terminator: terminator, isVerbose: isVerbose)
    }

    private func print(_ message: String, terminator: String = "\n", isVerbose: Bool) {
        guard isSilent == false else {
            return
        }
        guard isVerbose == false || (isVerbose && self.isVerbose) else {
            return
        }
        Swift.print(message, terminator: terminator)
        Swift.print(Colors.default.rawValue, terminator: "")
    }
}

fileprivate extension Sequence {
    func joinedDescription(separator: String) -> String {
        return map { "\($0)" }.joined(separator: separator)
    }
}
