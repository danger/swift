import Foundation

let cliLength = ProcessInfo.processInfo.arguments.count
do {
    if cliLength > 1 && "edit" == CommandLine.arguments[1] {
        try editDanger()
    } else {
        try runDanger()
    }
} catch {
    exit(1)
}
