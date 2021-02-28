import Foundation

public protocol ShellRunnerProtocol {
    @discardableResult
    func run(
        _ command: String,
        arguments: [String],
        environmentVariables: [String: String],
        outputFile: String?
    ) throws -> String
}

extension ShellRunnerProtocol {
    @discardableResult
    public func run(
        _ command: String,
        arguments: [String] = [],
        environmentVariables: [String: String] = [:],
        outputFile: String? = nil
    ) throws -> String {
        try run(
            command,
            arguments: arguments,
            environmentVariables: environmentVariables,
            outputFile: outputFile
        )
    }
}

public struct ShellRunner: ShellRunnerProtocol {
    public init() {}

    public func run(
        _ command: String,
        arguments: [String],
        environmentVariables: [String: String],
        outputFile: String?
    ) throws -> String {
        let command = "\(command) \(arguments.joined(separator: " "))"
        let process = Process()

        process.runShell(
            with: command,
            environmentVariables: environmentVariables,
            outputFile: outputFile
        )

        let outputPipe = Pipe()
        let errorPipe = Pipe()

        process.standardOutput = outputPipe
        process.standardError = errorPipe

        if #available(macOS 10.13, *) {
            try process.run()
        } else {
            process.launch()
        }

        process.waitUntilExit()

        if process.isSuccessfullyTerminated {
            return outputPipe.readAsString()
        }

        throw ShellError(
            command: command,
            exitCode: process.terminationStatus,
            message: errorPipe.readAsString(),
            output: outputPipe.readAsString()
        )
    }
}

// MARK: - Error Type

public struct ShellError: Error {
    let command: String
    let exitCode: Int32
    let message: String
    let output: String
}

extension ShellError: CustomStringConvertible {
    public var description: String {
        """
        Shell command exited with failure
            Command: \(command)
               Code: \(exitCode)
            Message: \(message)
             Output: \(output)
        """
    }
}

// MARK: - Private

private extension Pipe {
    func readAsString() -> String {
        let data = fileHandleForReading.readDataToEndOfFile()
        guard let string = String(data: data, encoding: .utf8) else {
            return ""
        }
        return string.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

private extension Process {
    var isSuccessfullyTerminated: Bool {
        terminationStatus == 0
    }

    func runShell(
        with command: String,
        environmentVariables: [String: String],
        outputFile: String?
    ) {
        let scriptOutputFile: String

        if let outputFile = outputFile {
            scriptOutputFile = " > \(outputFile)"
        } else {
            scriptOutputFile = ""
        }

        let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let fileURL = URL(fileURLWithPath: "/bin/sh")

        if #available(macOS 10.13, *) {
            self.currentDirectoryURL = currentDirectoryURL
            executableURL = fileURL
        } else {
            currentDirectoryPath = currentDirectoryURL.absoluteString
            launchPath = fileURL.absoluteString
        }

        arguments = ["-c", command + scriptOutputFile]
        environment = ProcessInfo.processInfo.environment.merging(environmentVariables) { current, _ in current }
    }
}
