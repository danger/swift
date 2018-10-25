import Foundation
import Danger

let cliLength = ProcessInfo.processInfo.arguments.count
do {
    let isVerbose = CommandLine.arguments.contains("--verbose") || (ProcessInfo.processInfo.environment["DEBUG"] != nil)
    let isSilent = CommandLine.arguments.contains("--silent")
    let logger = Logger(isVerbose: isVerbose, isSilent: isSilent)

    if cliLength > 1 {
        switch(CommandLine.arguments[1]) {
        case "ci", "local", "pr":
            let exitCode = try runDangerJSCommandToRunDangerSwift(CommandLine.arguments[1], logger: logger)
            exit(exitCode)
        case "edit":
            try editDanger(logger: logger)
        default:
            fatalError("Danger Swift does not support this argument, it only handles ci, local, pr & edit'")
        }
    } else {
        try runDanger(logger: logger)
    }
} catch {
    exit(1)
}
