import Foundation

public enum DangerfilePathFinder {
    public static func dangerfilePath(fromArguments arguments: [String] = CommandLine.arguments) -> String? {
        guard let dangerfileArgIndex = arguments.firstIndex(of: "--dangerfile"),
            dangerfileArgIndex + 1 < arguments.count
        else {
            return nil
        }

        return arguments[dangerfileArgIndex + 1]
    }
}
