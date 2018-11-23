import Foundation
import RunnerLib
import Logger

/// Version for showing in verbose mode
let DangerVersion = "0.7.1"

fileprivate func runCommand(_ command: DangerCommand, logger: Logger) throws {
    switch command {
    case .ci, .local, .pr:
        let exitCode = try runDangerJSCommandToRunDangerSwift(CommandLine.arguments[1], logger: logger)
        exit(exitCode)
    case .edit:
        try editDanger(logger: logger)
    case .runner:
        try runDanger(logger: logger)
    case .help:
        showCommandsList(logger: logger)
    }
}

fileprivate func showCommandsList(logger: Logger) {
    logger.logInfo("danger-swift [command]")
    logger.logInfo("")
    logger.logInfo("Commands:")
    logger.logInfo(DangerCommand.commandsListText, separator: "", terminator: "")
}

let cliLength = ProcessInfo.processInfo.arguments.count
do {
    let isVerbose = CommandLine.arguments.contains("--verbose") || (ProcessInfo.processInfo.environment["DEBUG"] != nil)
    let isSilent = CommandLine.arguments.contains("--silent")
    let logger = Logger(isVerbose: isVerbose, isSilent: isSilent)

    if cliLength > 1 {
        logger.debug("Launching Danger Swift \(CommandLine.arguments[1]) (v\(DangerVersion))")
        if let command = DangerCommand(rawValue: CommandLine.arguments[1]) {
            try runCommand(command, logger: logger)
        } else {
            fatalError("Danger Swift does not support this argument, it only handles ci, local, pr & edit'")
        }
    } else {
        try runDanger(logger: logger)
    }
} catch {
    exit(1)
}
