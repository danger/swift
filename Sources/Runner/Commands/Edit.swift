import Foundation
import Files
import Danger

@testable import MarathonCore

func editDanger() throws -> Void {
    let arguments: [String] = CommandLine.arguments
    let folderPath = "~/.danger-swift"
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

    let rootFolder = try fileSystem.createFolderIfNeeded(at: folderPath)
    let packageFolder = try rootFolder.createSubfolderIfNeeded(withName: "Packages")
    let scriptFolder = try rootFolder.createSubfolderIfNeeded(withName: "Scripts")

    let packageManager = try PackageManager(folder: packageFolder, printer: printer)
    let scriptManager = try ScriptManager(folder: scriptFolder, packageManager: packageManager, printer: printer)

    // Exit if a dangerfile was not found at any supported path
    guard let dangerfilePath = Runtime.getDangerfile() else {
        print("Could not find a Dangerfile")
        print("Please use a supported path: \(Runtime.supportedPaths)")
        exit(1)
    }

    guard let libPath = Runtime.getLibDangerPath() else {
        print("Could not find a libDanger to link against at any of: \(Runtime.potentialLibraryFolders)")
        print("Or via Homebrew, or Marathon")
        exit(1)
    }

    let letAbsoluteLibPath = try Folder(path: libPath).path

    let script = try scriptManager.script(atPath: dangerfilePath, allowRemote: true)
    let xcodeprojPath = try script.setupForEdit(arguments: arguments)

// Before:
//    OTHER_SWIFT_FLAGS = (
//        "-DXcode",
//    );
//
// After:
//    OTHER_SWIFT_FLAGS = (
//        "-I",
//        "/Users/orta/dev/projects/danger/danger-swift/.build/debug",
//        "-DXcode",
//    );

//  This is so we can dynamically link the danger library to the runtime generated xcodeproj
    let pbxproj = try File(path: xcodeprojPath  + "project.pbxproj")
    let content = try pbxproj.readAsString()
    let newContent = content.replacingOccurrences(of: "-DXcode\",", with: "-DXcode\", \"-I\", \"\(letAbsoluteLibPath)\"")
    
    try pbxproj.write(string:newContent)
    try script.watch(arguments: arguments)
}
