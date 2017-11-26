import Files
import MarathonCore

func getScriptManager() throws -> ScriptManager {
    let folder = "~/.danger-swift"
    let printFunction = { print($0) }
    let vPrintFunction = { (messageExpression: () -> String) in
        print(messageExpression())
    }
    
    let printer = Printer(
        outputFunction: printFunction,
        progressFunction: vPrintFunction,
        verboseFunction: vPrintFunction
    )
    let fileSystem = FileSystem()
    
    let rootFolder = try fileSystem.createFolderIfNeeded(at: folder)
    let packageFolder = try rootFolder.createSubfolderIfNeeded(withName: "Packages")
    let scriptFolder = try rootFolder.createSubfolderIfNeeded(withName: "Scripts")
    
    let packageManager = try PackageManager(folder: packageFolder, printer: printer)
    let config = ScriptManager.Config(prefix: "package: ", file: "Dangerplugins")

    return try ScriptManager(folder: scriptFolder, packageManager: packageManager, printer: printer, config: config)
}
