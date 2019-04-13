import DangerShellExecutor
import Foundation
import Logger

public func getDangerCommandPath(logger: Logger,
                                 args: [String] = CommandLine.arguments,
                                 shellOutExecutor: ShellExecuting = ShellExecutor()) throws -> String {
    if let dangerJSPathOptionIndex = args.firstIndex(of: DangerSwiftOption.dangerJSPath.rawValue),
        dangerJSPathOptionIndex + 1 < args.count {
        return args[dangerJSPathOptionIndex + 1]
    } else {
        logger.debug("Finding out where the danger executable is")
        return try shellOutExecutor.spawn("which danger", arguments: []).trimmingCharacters(in: .whitespaces)
    }
}
