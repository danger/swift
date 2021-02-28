import Foundation
import Logger
import ShellRunner

public func getDangerCommandPath(logger: Logger,
                                 args: [String] = CommandLine.arguments,
                                 shell: ShellRunnerProtocol = ShellRunner()) throws -> String {
    if let dangerJSPathOptionIndex = args.firstIndex(of: DangerSwiftOption.dangerJSPath.rawValue),
        dangerJSPathOptionIndex + 1 < args.count {
        return args[dangerJSPathOptionIndex + 1]
    } else {
        logger.debug("Finding out where the danger executable is")

        if let dangerJsPath = try? shell.spawn("command -v danger-js",
                                                          arguments: []).trimmingCharacters(in: .whitespaces),
            !dangerJsPath.isEmpty {
            return dangerJsPath.deletingSuffix("-js")
        } else {
            return try shell.spawn("command -v danger", arguments: []).trimmingCharacters(in: .whitespaces)
        }
    }
}

private extension String {
    func deletingSuffix(_ suffix: String) -> String {
        guard hasSuffix(suffix) else { return self }
        return String(dropLast(suffix.count))
    }
}
