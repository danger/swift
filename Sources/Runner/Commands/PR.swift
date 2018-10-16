import Foundation
import Danger

func runDangerJSPRToRunDangerSwift(logger: Logger) throws -> Void {
    let dangerJS = try getDangerJSPath()

    let proc = Process()
    proc.launchPath = dangerJS
    proc.arguments =  [ "pr", "--process", "danger-swift" ] + CommandLine.arguments

    let standardOutput = FileHandle.standardOutput
    proc.standardOutput = standardOutput
    proc.standardError = standardOutput

    proc.launch()
    proc.waitUntilExit()
}
