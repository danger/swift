import Foundation
import Logger

/// Version for showing in verbose mode
let DangerVersion = "0.7.1"

let cliLength = ProcessInfo.processInfo.arguments.count
do {
    let isVerbose = CommandLine.arguments.contains("--verbose") || (ProcessInfo.processInfo.environment["DEBUG"] != nil)
    let isSilent = CommandLine.arguments.contains("--silent")
    let logger = Logger(isVerbose: isVerbose, isSilent: isSilent)

    if cliLength > 1 {
        logger.debug("Launching Danger Swift \(CommandLine.arguments[1]) (v\(DangerVersion))")

        switch(CommandLine.arguments[1]) {
        case "ci", "local", "pr":
            let exitCode = try runDangerJSCommandToRunDangerSwift(CommandLine.arguments[1], logger: logger)
            exit(exitCode)
        case "edit":
            try editDanger(logger: logger)
        case "runner":
            try getDSLData(logger: logger, runDanger)

        default:
            fatalError("Danger Swift does not support this argument, it only handles ci, local, pr & edit'")
        }
    } else {
        logger.logInfo("Deprecated: Please don't use 'danger-swift' on its own to evaluate a Dangerfile.swift")
        logger.logInfo("            you can change it to `danger-swft runner` - this will get removed when")
        logger.logInfo("            danger hits 1.0 and replaced by help info")
        try getDSLData(logger: logger, runDanger)

    }
} catch {
    exit(1)
}
