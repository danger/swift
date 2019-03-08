import Foundation

// TODO: Get a logger into here this is real tricky
// because of the decoding from JSON nature of DangerDSL

public enum SpawnError: Error {
    case commandFailed(exitCode: Int32, stdout: String, stderr: String, task: Process)
}

internal class ShellExecutor {
    func execute(_ command: String,
                 arguments: [String] = [],
                 environmentVariables: [String: String] = [:]) -> String {
        let task = makeTask(for: command, with: arguments, environmentVariables: environmentVariables)

        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        task.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: String.Encoding.utf8)!
    }

    // Similar to above, but can throw, and throws with most of
    // what you'd probably need in a scripting environment
    func spawn(_ command: String,
               arguments: [String] = [],
               environmentVariables: [String: String] = [:]) throws -> String {
        let task = makeTask(for: command, with: arguments, environmentVariables: environmentVariables)

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

        throw SpawnError.commandFailed(exitCode: task.terminationStatus,
                                       stdout: stdoutString,
                                       stderr: stderrString,
                                       task: task)
    }

    private func makeTask(for command: String,
                          with arguments: [String],
                          environmentVariables: [String: String]) -> Process {
        let script = [command,
                      arguments.joined(separator: " ")].filter { !$0.isEmpty }.joined(separator: " ")
        let processEnv = ProcessInfo.processInfo.environment
        let task = Process()
        task.launchPath = processEnv["SHELL"]
        task.arguments = ["-l", "-c", script]
        task.environment = mergeEnvs(localEnv: environmentVariables, processEnv: processEnv)
        task.currentDirectoryPath = FileManager.default.currentDirectoryPath
        return task
    }

    private func mergeEnvs(localEnv: [String: String], processEnv: [String: String]) -> [String: String] {
        return localEnv.merging(processEnv, uniquingKeysWith: { (_, envString) -> String in
            envString
        })
    }
}
