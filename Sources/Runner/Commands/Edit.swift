import Foundation
import Danger

import Files
import MarathonCore

func editDanger() throws -> Void {
    
    // Exit if a dangerfile was not found at any supported path
    guard let dangerfilePath = Runtime.getDangerfile() else {
        print("Could not find a Dangerfile")
        print("Please use a supported path: \(Runtime.supportedPaths)")
        exit(1)
    }

    guard let libPath = Runtime.getLibDangerPath() else {
        print("Could not find a libDanger to link against at any of: \(Runtime.potentialLibraryFolders)")
        print("Or via Homebrew, or Marathon")
        exit(1)
    }

    let absoluteLibPath = try Folder(path: libPath).path

    let arguments = CommandLine.arguments
    let scriptManager = try getScriptManager()
    let script = try scriptManager.script(atPath: dangerfilePath, allowRemote: true)
    let xcodeprojPath = try script.setupForEdit(arguments: arguments)

    // Amends the Xcodeproj to include our build paths
    try addLibPathToXcodeProj(xcodeprojPath: xcodeprojPath, lib: absoluteLibPath)

    try script.watch(arguments: arguments)
}
