import Foundation
import Files

@testable import MarathonCore

//internal final class DangerfileEditTask: Task, Executable {
//    private typealias Error = EditError
//
//    // MARK: - Executable
//
//    func execute() throws {
//        let script = try scriptManager.script(atPath: "Dangerfile.swift", allowRemote: false)
//        try script.edit(arguments: arguments, open: true)
//    }
//}


func editDanger() throws -> Void {
//    let task = DangerfileEditTask(folder: ".", arguments: [], scriptManager: <#T##ScriptManager#>, packageManager: <#T##PackageManager#>, printer: <#T##Printer#>)
//    let script = try scriptManager.script(atPath: "Dangerfile.swift", allowRemote: false)
//    try script.edit(arguments: [], open: true)
    let arguments: [String] = CommandLine.arguments
    let folderPath = "~/.danger-swift"
    let printFunction = { print($0) }

    let printer = Printer(
        outputFunction: printFunction,
        progressFunction: printFunction,
        verboseFunction: printFunction
    )
    let fileSystem = FileSystem()

    let rootFolder = try fileSystem.createFolderIfNeeded(at: folderPath)
    let packageFolder = try rootFolder.createSubfolderIfNeeded(withName: "Packages")
    let scriptFolder = try rootFolder.createSubfolderIfNeeded(withName: "Scripts")

    let packageManager = try PackageManager(folder: packageFolder, printer: printer)
    let scriptManager = try ScriptManager(folder: scriptFolder, packageManager: packageManager, printer: printer)

    let script = try scriptManager.script(atPath: "Dangerfile.swift", allowRemote: true)
    let xcodeprojPath = try script.setupForEdit(arguments: arguments)

//    let xcodeproj = try File(path: xcodeprojPath)
    let pbxproj = try File(path: xcodeprojPath  + "project.pbxproj")
    let content = try pbxproj.readAsString()
    let newContent = content.replacingOccurrences(of: "-DXcode\",", with: "-DXcode\", \"-I\", \"/Users/orta/dev/projects/danger/danger-swift/.build/debug\"")
    try pbxproj.write(string:newContent)

//    let copy = try moduleFolder.createFile(named: dependencyScriptFile.name)
//    try copy.write(data: dependencyScriptFile.read())


    print(pbxproj)

    try script.watch(arguments: arguments)

//    }
//    // TODO: Split this \/ into two functions, one that generates the xcodeproj
//    //       and another that opens it
//    try script.edit(arguments: arguments, open: true)

// Before
//    OTHER_SWIFT_FLAGS = (
//        "-DXcode",
//    );

// After
//    OTHER_SWIFT_FLAGS = (
//        "-I",
//        "/Users/orta/dev/projects/danger/danger-swift/.build/debug",
//        "-DXcode",
//    );

    print("OK")

}


//func makePrinter(using printFunction: @escaping PrintFunction,
//                                command: Command,
//                                arguments: [String]) -> Printer {
//    let progressFunction = makeProgressPrintingFunction(using: printFunction, command: command, arguments: arguments)
//    let verboseFunction = makeVerbosePrintingFunction(using: progressFunction, arguments: arguments)
//
//}

