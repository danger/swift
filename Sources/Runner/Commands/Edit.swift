import DangerDependenciesResolver
import Foundation
import Logger
import RunnerLib

func editDanger(version dangerSwiftVersion: String, logger: Logger) throws {
    let fileManager = FileManager.default
    let dangerfilePath: String
    
    if let dangerfileArgumentPath = DangerfilePathFinder.dangerfilePath() {
        dangerfilePath = dangerfileArgumentPath.fullPath
    } else {
        dangerfilePath = (Runtime.getDangerfile() ?? "Dangerfile.swift").fullPath
    }

    if !fileManager.fileExists(atPath: dangerfilePath) {
        createDangerfile(dangerfilePath)
    }
    
    let absoluteLibPath: String
    let libsImport: [String]

    if let spmDanger = SPMDanger() {
        spmDanger.buildDependencies()
        absoluteLibPath = spmDanger.buildFolder
        libsImport = spmDanger.xcodeImportFlags
    } else {
        guard let libPath = Runtime.getLibDangerPath() else {
            let potentialFolders = Runtime.potentialLibraryFolders
            logger.logError("Could not find a libDanger to link against at any of: \(potentialFolders)",
                            "Or via Homebrew, or Marathon",
                            separator: "\n")
            exit(1)
        }
        absoluteLibPath = libPath.fullPath
        libsImport = ["-l Danger"]
    }

    guard let dangerfileContent = try? String(contentsOfFile: dangerfilePath) else {
        logger.logError("Could not read the dangerPath")
        exit(1)
    }

    let importsFinder = ImportsFinder()
    let importedFiles = importsFinder.findImports(inString: dangerfileContent)
        .map { importsFinder.resolveImportPath($0, relativeTo: dangerfilePath) }

    let scriptManager = try getScriptManager(forDangerSwiftVersion: dangerSwiftVersion,
                                             logger: logger)
    let script = try scriptManager.script(atPath: dangerfilePath)

    try script.setupForEdit(importedFiles: importedFiles)
    try script.watch(importedFiles: importedFiles)
}

private func createDangerfile(_ dangerfilePath: String) {
    let template = "import Danger \nlet danger = Danger()"
    let data = Data(template.utf8)

    FileManager.default.createFile(atPath: dangerfilePath, contents: data, attributes: [:])
}
