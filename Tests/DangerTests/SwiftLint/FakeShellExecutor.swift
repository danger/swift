@testable import Danger
import DangerExecutor

final class FakeShellExecutor: ShellExecuting {
    typealias Invocation = (command: String, arguments: [String], environmentVariables: [String: String])

    var invocations = [Invocation]() /// All of the invocations received by this instance.
    var output = "[]" /// This is returned by `execute` as the process' standard output. We default to an empty JSON array.

    func execute(_ command: String, arguments: [String], environmentVariables: [String: String]) -> String {
        invocations.append((command: command, arguments: arguments, environmentVariables: environmentVariables))
        return output
    }

    func spawn(_ command: String, arguments: [String], environmentVariables: [String: String]) throws -> String {
        invocations.append((command: command, arguments: arguments, environmentVariables: environmentVariables))
        return output
    }
}
