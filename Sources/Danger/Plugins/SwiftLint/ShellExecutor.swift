import Foundation

// TODO: Get a logger into here this is real tricky
// because of the decoding from JSON nature of DangerDSL

public enum SpawnError: Error {
    case commandFailed(exitCode: Int32, stdout: String, stderr: String, task: Process)
}

internal class ShellExecutor {
    func execute(_ command: String, arguments: [String] = [], environmentVariables: [String: String] = [:]) -> String {
        let script = [command,
                      arguments.joined(separator: " ")].filter { !$0.isEmpty }.joined(separator: " ")
        print("Executing \(script)")

        var env = ProcessInfo.processInfo.environment
        let task = Process()
        task.launchPath = env["SHELL"]
        task.arguments = ["-l", "-c", script]
        task.environment = environmentVariables
        task.currentDirectoryPath = FileManager.default.currentDirectoryPath

        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        task.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: String.Encoding.utf8)!
    }

    // Similar to above, but can throw, and throws with most of
    // what you'd probably need in a scripting environment
    func spawn(_ command: String, arguments: [String] = [], environmentVariables: [String] = []) throws -> String {
        let script = [environmentVariables.joined(separator: " "),
                      command,
                      arguments.joined(separator: " ")].filter { !$0.isEmpty }.joined(separator: " ")

        var env = ProcessInfo.processInfo.environment
        let task = Process()
        task.launchPath = env["SHELL"]
        task.arguments = ["-l", "-c", script]
        task.currentDirectoryPath = FileManager.default.currentDirectoryPath

        let stdout = Pipe()
        task.standardOutput = stdout
        let stderr = Pipe()
        task.standardError = stderr
        task.launch()
        task.waitUntilExit()

        // Pull out the STDOUT as a string because we'll need that regardless
        let stdoutData = stdout.fileHandleForReading.readDataToEndOfFile()
        let stdoutString = String(data: stdoutData, encoding: String.Encoding.utf8)!

        // 0 is no problems in unix land
        if task.terminationStatus == 0 {
            return stdoutString
        }

        // OK, so it failed, raise a new error with all the useful metadata
        let stderrData = stdout.fileHandleForReading.readDataToEndOfFile()
        let stderrString = String(data: stderrData, encoding: String.Encoding.utf8)!

        throw SpawnError.commandFailed(exitCode: task.terminationStatus, stdout: stdoutString, stderr: stderrString, task: task)
    }
}
