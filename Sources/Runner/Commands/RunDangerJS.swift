import Foundation
import Danger

func runDangerJSCommandToRunDangerSwift(_ command: String, logger: Logger) throws -> Int32 {
    let dangerJS = try getDangerJSPath(logger)

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

    let standardOutput = FileHandle.standardOutput
    proc.standardOutput = standardOutput
    proc.standardError = standardOutput

    logger.debug("Running: \(proc.launchPath!) \(proc.arguments!.joined(separator: " ")) ")
    proc.launch()
    proc.waitUntilExit()

    return proc.terminationStatus
}
