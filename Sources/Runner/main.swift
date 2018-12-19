import Foundation
import Logger
import RunnerLib

/// Version for showing in verbose mode
let DangerVersion = "0.8.0"

private func runCommand(_ command: DangerCommand, logger: Logger) throws {
    switch command {
    case .ci, .local, .pr:
        let exitCode = try runDangerJSCommandToRunDangerSwift(command, logger: logger)
        exit(exitCode)
    case .edit:
        try editDanger(logger: logger)
    case .runner:
        try runDanger(logger: logger)
    }
}

let cliLength = ProcessInfo.processInfo.arguments.count
do {
    let isVerbose = CommandLine.arguments.contains("--verbose") || (ProcessInfo.processInfo.environment["DEBUG"] != nil)
    let isSilent = CommandLine.arguments.contains("--silent")
    let logger = Logger(isVerbose: isVerbose, isSilent: isSilent)

    if cliLength > 1 {
        logger.debug("Launching Danger Swift \(CommandLine.arguments[1]) (v\(DangerVersion))")

        let command = DangerCommand(rawValue: CommandLine.arguments[1])

        guard !CommandLine.arguments.contains("--help") else {
            HelpMessagePresenter.showHelpMessage(command: command, logger: logger)
            exit(0)
        }

        if command != nil {
            try runCommand(command!, logger: logger)
        } else {
            fatalError("Danger Swift does not support this argument, it only handles ci, local, pr & edit'")
        }
    } else {
        try runDanger(logger: logger)
    }
} catch {
    exit(1)
}
