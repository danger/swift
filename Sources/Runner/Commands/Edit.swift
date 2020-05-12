import DangerDependenciesResolver
import Foundation
import Logger
import RunnerLib

func editDanger(logger: Logger) throws {
    let dangerfilePath: String

    if let dangerfileArgumentPath = DangerfilePathFinder.dangerfilePath() {
        dangerfilePath = dangerfileArgumentPath
    } else {
        dangerfilePath = Runtime.getDangerfile() ?? "Dangerfile.swift"
    }

    if !FileManager.default.fileExists(atPath: dangerfilePath) {
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

    let scriptManager = try getScriptManager(logger)
    let script = try scriptManager.script(atPath: dangerfilePath)

    let configPath = NSTemporaryDirectory() + "config.xcconfig"

    try createConfig(atPath: configPath, libPath: absoluteLibPath, libsImport: libsImport)

    try script.setupForEdit(importedFiles: importedFiles, configPath: configPath)
    try script.watch(importedFiles: importedFiles)
}

private func createDangerfile(_ dangerfilePath: String) {
    let template = "import Danger \nlet danger = Danger()"
    let data = Data(template.utf8)

    FileManager.default.createFile(atPath: dangerfilePath, contents: data, attributes: [:])
}

private extension String {
    var fullPath: String {
        if hasPrefix("/") {
            return self
        } else {
            return FileManager.default.currentDirectoryPath.appendingPath(self)
        }
    }

    func appendingPath(_ path: String) -> String {
        if hasSuffix("/") {
            return self + path
        } else {
            return self + "/" + path
        }
    }
}
