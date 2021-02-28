import RunnerLib
import ShellRunner

final class ShellRunnerMock: ShellRunnerProtocol {
    var receivedCommands: [String] = []
    var result: (String) -> String = { _ in "" }

    func execute(_ command: String, arguments: [String], environmentVariables _: [String: String], outputFile _: String?) -> String {
        let receivedCommand = makeReceivedCommand(command, arguments: arguments)
        receivedCommands.append(receivedCommand)
        return result(receivedCommand)
    }

    func spawn(_ command: String, arguments: [String], environmentVariables _: [String: String], outputFile _: String?) throws -> String {
        let receivedCommand = makeReceivedCommand(command, arguments: arguments)
        receivedCommands.append(receivedCommand)
        return result(receivedCommand)
    }

    private func makeReceivedCommand(_ command: String, arguments: [String]) -> String {
        command + (arguments.isEmpty ? "" : " " + arguments.joined(separator: " "))
    }
}
