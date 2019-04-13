import DangerShellExecutor
import RunnerLib

final class MockedExecutor: ShellExecuting {
    var receivedCommand: String!
    var result = ""

    func execute(_ command: String, arguments: [String], environmentVariables _: [String: String]) -> String {
        receivedCommand = command + " " + arguments.joined(separator: " ")
        return result
    }

    func spawn(_ command: String, arguments _: [String], environmentVariables _: [String: String]) throws -> String {
        receivedCommand = command
        return result
    }
}
