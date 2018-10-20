import Foundation
import Danger

func runDangerJSCommandToRunDangerSwift(_ command: String, logger: Logger) throws -> Void {
    let dangerJS = try getDangerJSPath()

    let proc = Process()
    proc.environment = ProcessInfo.processInfo.environment
    proc.launchPath = dangerJS

    let unusedArgs = CommandLine.arguments.filter { arg in
        arg !== "danger-swift" && arg !== command
    }
    proc.arguments =  [ command, "--process", "danger-swift" ] + unusedArgs

    let standardOutput = FileHandle.standardOutput
    proc.standardOutput = standardOutput
    proc.standardError = standardOutput

    logger.logInfo("Running: \(proc.launchPath!) \(proc.arguments!.joined(separator: " ")) ")
    proc.launch()
    proc.waitUntilExit()
}
