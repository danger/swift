import Foundation
import RunnerLib
import Logger

func runDangerJSCommandToRunDangerSwift(_ command: String, logger: Logger) throws -> Int32 {
    let dangerJS = try getDangerCommandPath(command, logger: logger)

    let proc = Process()
    proc.environment = ProcessInfo.processInfo.environment
    proc.launchPath = dangerJS

    let unusedArgs = CommandLine.arguments.filter { arg in
        !arg.contains("danger-swift") && arg != command
    }

    var dangerSwiftCommand = "danger-swift"
    // Special-case running inside the danger dev dir
    let fileManager = FileManager.default
    if fileManager.fileExists(atPath: ".build/debug/danger-swift") {
        dangerSwiftCommand = ".build/debug/danger-swift"
    }

    proc.arguments =  [ command, "--process", dangerSwiftCommand ] + unusedArgs

    proc.standardOutput = FileHandle.standardOutput
    proc.standardInput = FileHandle.standardInput
    proc.standardError = FileHandle.standardError

    logger.debug("Running: \(proc.launchPath!) \(proc.arguments!.joined(separator: " ")) ")
    proc.launch()
    proc.waitUntilExit()

    return proc.terminationStatus
}
