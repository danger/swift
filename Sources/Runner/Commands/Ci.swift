import Foundation
import Danger

func runDangerJSToRunDangerSwift(logger: Logger) throws -> Void {
    let dangerJS = try getDangerJSPath(logger)

    let proc = Process()
    proc.launchPath = dangerJS
    proc.arguments =  ["process", "danger-swift"] + CommandLine.arguments

    let standardOutput = FileHandle.standardOutput
    proc.standardOutput = standardOutput
    proc.standardError = standardOutput

    proc.launch()
    proc.waitUntilExit()
}
