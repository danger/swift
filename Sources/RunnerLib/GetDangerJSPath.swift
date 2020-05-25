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

        if let dangerJsPath = try? shellOutExecutor.spawn("command -v danger-js", arguments: []).trimmingCharacters(in: .whitespaces),
            !dangerJsPath.isEmpty {
            return dangerJsPath
        } else {
            return try shellOutExecutor.spawn("command -v danger", arguments: []).trimmingCharacters(in: .whitespaces)
        }
    }
}
