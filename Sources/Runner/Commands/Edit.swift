import Foundation
import RunnerLib

import Files
import Logger
import MarathonCore

func editDanger(logger: Logger) throws {
    let createDangerfile = { () -> String in
        do {
            let template = "import Danger \n let danger = Danger()"
            let data = template.data(using: .utf8)!
            return try FileSystem().createFile(at: "Dangerfile.swift", contents: data).path
        } catch {
            logger.logError("Could not find or generate a Dangerfile")
            exit(1)
        }
    }

    // If dangerfile was not found, attempt to create one at Dangerfile.swift
    let dangerfilePath = Runtime.getDangerfile() ?? createDangerfile()

    let absoluteLibPath: String
    let libName: String

    if SPMDanger.isSPMDanger() {
        SPMDanger.buildDepsIfNeeded()
        absoluteLibPath = FileManager.default.currentDirectoryPath + "/" + SPMDanger.buildFolder
        libName = SPMDanger.depsLibName
    } else {
        guard let libPath = Runtime.getLibDangerPath() else {
            let potentialFolders = Runtime.potentialLibraryFolders
            logger.logError("Could not find a libDanger to link against at any of: \(potentialFolders)",
                            "Or via Homebrew, or Marathon",
                            separator: "\n")
            exit(1)
        }

        absoluteLibPath = try Folder(path: libPath).path
        libName = "Danger"
    }

    guard let dangerfileContent = try? File(path: dangerfilePath).readAsString() else {
        logger.logError("Could not read the dangerPath")
        exit(1)
    }

    let importsFinder = ImportsFinder()
    let importedFiles = importsFinder.findImports(inString: dangerfileContent)

    let arguments = CommandLine.arguments
    logger.logInfo("Script manager")
    let scriptManager = try getScriptManager(logger)
    logger.logInfo("Create script")
    let script = try scriptManager.script(atPath: dangerfilePath, allowRemote: true)

    let path = NSTemporaryDirectory()
    let configPath = path + "config.xcconfig"

    try createConfig(atPath: configPath, libPath: absoluteLibPath, libName: libName)
    logger.logInfo("Config created at \(configPath)")

    try script.setupForEdit(arguments: arguments, importedFiles: importedFiles, configPath: configPath)
    logger.logInfo("Edit")

    try script.watch(arguments: arguments, importedFiles: importedFiles)
}
