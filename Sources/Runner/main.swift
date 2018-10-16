import Foundation
import Danger

let cliLength = ProcessInfo.processInfo.arguments.count
do {
    let isVerbose = CommandLine.arguments.contains("--verbose") || (ProcessInfo.processInfo.environment["DEBUG"] != nil)
    let isSilent = CommandLine.arguments.contains("--silent")
    let logger = Logger(isVerbose: isVerbose, isSilent: isSilent)

    if cliLength > 1 && "edit" == CommandLine.arguments[1] {
        try editDanger(logger: logger)
    } else if cliLength > 1 && "ci" == CommandLine.arguments[1] {
        try runDangerJSToRunDangerSwift(logger: logger)
    } else if cliLength > 1 && "pr" == CommandLine.arguments[1] {
        try runDangerJSPRToRunDangerSwift(logger: logger)
    } else {
        // TODO: Deprecate
        try runDanger(logger: logger)
    }
} catch {
    exit(1)
}
