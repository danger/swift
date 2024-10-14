import DangerDependenciesResolver
import Foundation
import Logger

func getScriptManager(forDangerSwiftVersion dangerSwiftVersion: String,
                      logger: Logger) throws -> ScriptManager
{
    let homeFolder: String
    
    if #available(OSX 10.12, *) {
        homeFolder = FileManager.default.homeDirectoryForCurrentUser.path
    } else {
        homeFolder = NSHomeDirectory()
    }

    let folder = "\(homeFolder)/.danger-swift/"

    let packageFolder = folder + "Packages/"
    let scriptFolder = folder + "Scripts/"

    let packageManager = try PackageManager(folder: packageFolder, logger: logger)

    return try ScriptManager(folder: scriptFolder,
                             dangerSwiftVersion: dangerSwiftVersion,
                             packageManager: packageManager,
                             logger: logger)
}
