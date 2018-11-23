import Foundation
import RunnerLib
import Logger

/// Version for showing in verbose mode
let DangerVersion = "0.7.1"

fileprivate func runCommand(_ command: DangerCommand, logger: Logger) throws {
    switch command {
    case .ci, .local, .pr:
        let exitCode = try runDangerJSCommandToRunDangerSwift(command, logger: logger)
        exit(exitCode)
    case .edit:
        try editDanger(logger: logger)
    case .runner:
        try getDSLData(logger: logger, runDanger)
    }
}

let cliLength = ProcessInfo.processInfo.arguments.count
do {
    let isVerbose = CommandLine.arguments.contains("--verbose") || (ProcessInfo.processInfo.environment["DEBUG"] != nil)
    let isSilent = CommandLine.arguments.contains("--silent")
    let logger = Logger(isVerbose: isVerbose, isSilent: isSilent)
    logger.debug("Launching Danger Swift (v\(DangerVersion))")

    if cliLength > 1 {
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
        // [SOON]
        // but I can't think of a way to get Danger JS to handle the sub-commands from Danger Swift yet
        //
        // logger.logInfo("Deprecated: Please don't use 'danger-swift' on its own to evaluate a Dangerfile.swift")
        // logger.logInfo("            you can change it to `danger-swft runner` - this will get removed when")
        // logger.logInfo("            danger hits 1.0 and replaced by help info")
        //
        try getDSLData(logger: logger, runDanger)
    }
} catch {
    exit(1)
}
