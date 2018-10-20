import Foundation
import Danger

func runDangerJSCommandToRunDangerSwift(_ command: String, logger: Logger) throws -> Void {
    let dangerJS = try getDangerJSPath()

    let proc = Process()
    proc.launchPath = dangerJS
    proc.arguments =  [ command, "--process", "danger-swift" ] + CommandLine.arguments

    let standardOutput = FileHandle.standardOutput
    proc.standardOutput = standardOutput
    proc.standardError = standardOutput

    proc.launch()
    proc.waitUntilExit()
}
