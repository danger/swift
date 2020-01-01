import Foundation

public enum SpawnError: Error {
    case commandFailed(command: String, exitCode: Int32, stdout: String, stderr: String)
}

public protocol ShellExecuting {
    @discardableResult
    func execute(_ command: String,
                 arguments: [String],
                 environmentVariables: [String: String],
                 outputFile: String?) -> String

    @discardableResult
    func spawn(_ command: String,
               arguments: [String],
               environmentVariables: [String: String],
               outputFile: String?) throws -> String
}

extension ShellExecuting {
    @discardableResult
    public func execute(_ command: String,
                        arguments: [String]) -> String {
        return execute(command, arguments: arguments, environmentVariables: [:], outputFile: nil)
    }

    @discardableResult
    func execute(_ command: String,
                 arguments: [String],
                 environmentVariables: [String: String]) -> String {
        return execute(command, arguments: arguments, environmentVariables: environmentVariables, outputFile: nil)
    }

    @discardableResult
    public func spawn(_ command: String,
                      arguments: [String]) throws -> String {
        return try spawn(command, arguments: arguments, environmentVariables: [:], outputFile: nil)
    }

    @discardableResult
    func spawn(_ command: String,
               arguments: [String],
               environmentVariables: [String: String]) throws -> String {
        return try spawn(command, arguments: arguments, environmentVariables: environmentVariables, outputFile: nil)
    }
}

public struct ShellExecutor: ShellExecuting {
    public init() {}

    public func execute(_ command: String,
                        arguments: [String],
                        environmentVariables: [String: String],
                        outputFile: String?) -> String {
        let task = makeTask(for: command,
                            with: arguments,
                            environmentVariables: environmentVariables,
                            outputFile: outputFile)

        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        task.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // Similar to above, but can throw, and throws with most of
    // what you'd probably need in a scripting environment
    public func spawn(_ command: String,
                      arguments: [String],
                      environmentVariables: [String: String],
                      outputFile: String?) throws -> String {
        let task = makeTask(for: command,
                            with: arguments,
                            environmentVariables: environmentVariables,
                            outputFile: outputFile)

        let stdout = Pipe()
        task.standardOutput = stdout
        let stderr = Pipe()
        task.standardError = stderr
        task.launch()
        task.waitUntilExit()

        // Pull out the STDOUT as a string because we'll need that regardless
        let stdoutData = stdout.fileHandleForReading.readDataToEndOfFile()
        let stdoutString = String(data: stdoutData, encoding: .utf8)!

        // 0 is no problems in unix land
        if task.terminationStatus == 0 {
            return stdoutString.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        // OK, so it failed, raise a new error with all the useful metadata
        let stderrData = stderr.fileHandleForReading.readDataToEndOfFile()
        let stderrString = String(data: stderrData, encoding: .utf8)!

        throw SpawnError.commandFailed(command: command,
                                       exitCode: task.terminationStatus,
                                       stdout: stdoutString,
                                       stderr: stderrString)
    }

    private func makeTask(for command: String,
                          with arguments: [String],
                          environmentVariables: [String: String],
                          outputFile: String?) -> Process {
        let scriptOutputFile: String

        if let outputFile = outputFile {
            scriptOutputFile = " > \(outputFile)"
        } else {
            scriptOutputFile = ""
        }

        let script = "\(command) \(arguments.joined(separator: " "))" + scriptOutputFile

        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", script]
        task.environment = mergeEnvs(localEnv: environmentVariables, processEnv: ProcessInfo.processInfo.environment)
        task.currentDirectoryPath = FileManager.default.currentDirectoryPath
        return task
    }

    private func mergeEnvs(localEnv: [String: String], processEnv: [String: String]) -> [String: String] {
        return localEnv.merging(processEnv, uniquingKeysWith: { (_, envString) -> String in
            envString
        })
    }
}
