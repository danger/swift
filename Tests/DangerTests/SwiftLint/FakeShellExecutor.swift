@testable import Danger

class FakeShellExecutor: ShellExecutor {
    typealias Invocation = (command: String, arguments: [String])

    var invocations = Array<Invocation>() /// All of the invocations received by this instance.
    var output = "[]" /// This is returned by `execute` as the process' standard output. We default to an empty JSON array.

    override func execute(_ command: String, arguments: String...) -> String {
        invocations.append((command: command, arguments: arguments))
        return output
    }
}
