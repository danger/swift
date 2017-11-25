import Foundation

let cliLength = ProcessInfo.processInfo.arguments.count
print(ProcessInfo.processInfo.arguments)
if cliLength > 1 && "edit" == CommandLine.arguments[1] {
    try editDanger()
} else {
    runDanger()
}
