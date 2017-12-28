import Foundation
import Danger

let cliLength = ProcessInfo.processInfo.arguments.count
do {
    let isVerbose = CommandLine.arguments.contains("--verbose")
    let isSilent = CommandLine.arguments.contains("--silent")
    let logger = Logger(isVerbose: isVerbose, isSilent: isSilent)
    if cliLength > 1 && "edit" == CommandLine.arguments[1] {
        try editDanger(logger: logger)
    } else {
        try runDanger(logger: logger)
    }
} catch {
    exit(1)
}
