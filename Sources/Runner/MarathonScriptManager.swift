import Files
import Logger
import MarathonCore

func getScriptManager(_ logger: Logger) throws -> ScriptManager {
    let folder = "~/.danger-swift"

    let printFunction: PrintFunction = { logger.logInfo($0) }
    let progressFunc = makeProgressPrintingFunction(logger: logger)
    let verbosePrint = makeVerbosePrintingFunction(logger)

    let printer = Printer(
        outputFunction: printFunction,
        progressFunction: progressFunc,
        verboseFunction: verbosePrint
    )
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

    let packageManager = try PackageManager(folder: packageFolder, printer: printer)
    let config = ScriptManager.Config(prefix: "package: ", file: "Dangerplugins")

    return try ScriptManager(folder: scriptFolder, packageManager: packageManager, printer: printer, config: config)
}

private func makeProgressPrintingFunction(logger: Logger) -> VerbosePrintFunction { { (messageExpression: () -> String) in
    let message = messageExpression()
    logger.debug(message)
}
}

private func makeVerbosePrintingFunction(_ logger: Logger) -> VerbosePrintFunction { { (messageExpression: () -> String) in
    let message = "\u{001B}[0;3m\(messageExpression())\u{001B}[0;23m"
    logger.debug(message)
}
}
