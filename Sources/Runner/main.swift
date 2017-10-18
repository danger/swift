import Foundation

let cliLength = CommandLine.arguments.count
if cliLength > 0 && "edit" == CommandLine.arguments[0] {
    editDanger()
} else {
    runDanger()
}
