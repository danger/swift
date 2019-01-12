import RunnerLib

final class MockedExecutor: ShellOutExecuting {
    var receivedCommand: String!
    var result = ""

    func shellOut(command: String) throws -> String {
        receivedCommand = command
        return result
    }
}
