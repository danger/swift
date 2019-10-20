import DangerDependenciesResolver
import Files
import Logger

func getScriptManager(_: Logger) throws -> ScriptManager {
    let folder = "~/.danger-swift"

    let fileSystem = FileSystem()

    let rootFolder = try fileSystem.createFolderIfNeeded(at: folder)
    let packageFolder = try rootFolder.createSubfolderIfNeeded(withName: "Packages")
    let scriptFolder = try rootFolder.createSubfolderIfNeeded(withName: "Scripts")

    // Move over local cache for repos, and build artefacts to save git/compile time
    do {
        let localBuild = try fileSystem.currentFolder.subfolder(named: ".build")
        let generated = try packageFolder.createSubfolderIfNeeded(withName: "Generated")
        try localBuild.copy(to: generated)
    } catch {}

    let packageManager = try PackageManager(folder: packageFolder.path)

    return try ScriptManager(folder: scriptFolder.path, packageManager: packageManager)
}
