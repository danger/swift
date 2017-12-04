import Foundation
import Danger

import Files
import MarathonCore

func editDanger() throws -> Void {

    let createDangerfile = { () -> String in
        do {
            let template = "import Danger \n let danger = Danger()"
            let data = template.data(using: .utf8)!
            return try FileSystem().createFile(at: "Dangerfile.swift", contents: data).path
        } catch {
            print("Could not find or generate a Dangerfile")
            exit(1)
        }
    }

    // If dangerfile was not found, attempt to create one at Dangerfile.swift
    let dangerfilePath = Runtime.getDangerfile() ?? createDangerfile()

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
