import Foundation
import Logger
import ShellOut

public func getDangerCommandPath(logger: Logger, args: [String] = CommandLine.arguments, shellOutExecutor: ShellOutExecuting = ShellOutExecutor()) throws -> String {
    if let dangerJSPathOptionIndex = args.firstIndex(of: DangerSwiftOption.dangerJSPath.rawValue),
        dangerJSPathOptionIndex + 1 < args.count {
        return args[dangerJSPathOptionIndex + 1]
    } else {
        logger.debug("Finding out where the danger executable is")
        return try shellOutExecutor.shellOut(command: "which danger").trimmingCharacters(in: .whitespaces)
    }
}
