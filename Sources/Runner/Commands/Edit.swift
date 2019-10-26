import DangerDependenciesResolver
import Files
import Foundation
import Logger
import RunnerLib

func editDanger(logger: Logger) throws {
    let dangerfilePath: String

    if let dangerfileArgumentPath = DangerfilePathFinder.dangerfilePath() {
        dangerfilePath = dangerfileArgumentPath

        if !FileManager.default.fileExists(atPath: dangerfileArgumentPath) {
            createDangerfile(dangerfileArgumentPath)
        }

    } else {
        dangerfilePath = Runtime.getDangerfile() ?? createDangerfile("Dangerfile.swift")
    }

    let absoluteLibPath: String
    let libsImport: [String]

    if let spmDanger = SPMDanger() {
        spmDanger.buildDependencies()
        absoluteLibPath = FileManager.default.currentDirectoryPath + "/" + SPMDanger.buildFolder
        libsImport = spmDanger.xcodeImportFlags
    } else {
        guard let libPath = Runtime.getLibDangerPath() else {
            let potentialFolders = Runtime.potentialLibraryFolders
            logger.logError("Could not find a libDanger to link against at any of: \(potentialFolders)",
                            "Or via Homebrew, or Marathon",
                            separator: "\n")
            exit(1)
        }

        absoluteLibPath = try Folder(path: libPath).path
        libsImport = ["-l Danger"]
    }

    guard let dangerfileContent = try? File(path: dangerfilePath).readAsString() else {
        logger.logError("Could not read the dangerPath")
        exit(1)
    }

    let importsFinder = ImportsFinder()
    let importedFiles = importsFinder.findImports(inString: dangerfileContent)

    let scriptManager = try getScriptManager(logger)
    let script = try scriptManager.script(atPath: dangerfilePath)

    let configPath = NSTemporaryDirectory() + "config.xcconfig"

    try createConfig(atPath: configPath, libPath: absoluteLibPath, libsImport: libsImport)

    try script.setupForEdit(importedFiles: importedFiles, configPath: configPath)
    try script.watch(importedFiles: importedFiles)
}

@discardableResult
private func createDangerfile(_ dangerfilePath: String) -> String {
    do {
        let template = "import Danger \nlet danger = Danger()"
        let data = template.data(using: .utf8)!
        return try FileSystem().createFile(at: dangerfilePath, contents: data).path
    } catch {
        logger.logError("Could not find or generate a Dangerfile")
        exit(1)
    }
}
