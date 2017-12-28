import Foundation
import Danger

import Files
import MarathonCore

func runDanger(logger: Logger) throws -> Void {
    // Pull in the JSON from Danger JS
    let standardInput = FileHandle.standardInput
    let input = standardInput.readDataToEndOfFile()
    let fileManager = FileManager.default

    // Set up some example paths for us to work with
    let path = NSTemporaryDirectory()
    let dslJSONPath = path + "danger-dsl.json"
    let dangerResponsePath = path + "danger-response.json"
    // Create the DSL JSON file for the the runner to read from
    if !fileManager.createFile(atPath: dslJSONPath, contents: input, attributes: nil) {
        logger.logError("Could not create a temporary file for the Dangerfile DSL at: \(dslJSONPath)")
        exit(1)
    }

    // Exit if a dangerfile was not found at any supported path
    guard let dangerfilePath = Runtime.getDangerfile() else {
        logger.logError("Could not find a Dangerfile",
                        "Please use a supported path: \(Runtime.supportedPaths)",
                        separator: "\n")
        exit(1)
    }

    guard let libDangerPath = Runtime.getLibDangerPath() else {
        let potentialFolders = Runtime.potentialLibraryFolders
        logger.logError("Could not find a libDanger to link against at any of: \(potentialFolders)",
                        "Or via Homebrew, or Marathon",
                        separator: "\n")
        exit(1)
    }

    var libArgs: [String] = []
    libArgs += ["-L", libDangerPath] // Link to libDanger inside this folder
    libArgs += ["-I", libDangerPath] // Find libDanger inside this folder

    // Set up plugin infra
    let importsOnly =  try File(path: dangerfilePath).readAsString()
    let importExternalDeps = importsOnly.components(separatedBy: .newlines).filter { $0.hasPrefix("import") && $0.contains("package: ") }

    if (importExternalDeps.count > 0) {
        try Folder(path: ".").createFileIfNeeded(withName: "_dangerfile_imports.swift")
        let tempDangerfile = try File(path: "_dangerfile_imports.swift")
        try tempDangerfile.write(string: importExternalDeps.joined(separator: "\n"))
        defer { try? tempDangerfile.delete() }

        let scriptManager = try getScriptManager()
        let script = try scriptManager.script(atPath: tempDangerfile.path, allowRemote: true)

        try script.build()
        let marathonPath = script.folder.path
        let artifactPaths = [".build/debug", ".build/release"]

        let marathonLibPath = artifactPaths.first(where: { fileManager.fileExists(atPath: marathonPath + $0 ) })
        if marathonLibPath != nil {
            libArgs += ["-L", marathonPath + marathonLibPath!]
            libArgs += ["-I", marathonPath + marathonLibPath!]
            libArgs += ["-lMarathonDependencies"]
        }
    }

    // Example commands:
    //
    //
    // ## Run the full system:
    // swift build; env DANGER_GITHUB_API_TOKEN='MY_TOKEN' DANGER_FAKE_CI="YEP" DANGER_TEST_REPO='artsy/eigen' DANGER_TEST_PR='2408' danger process .build/debug/danger-swift --verbose --text-only
    //
    // ## Run compilation and eval of the Dangerfile:
    // swiftc --driver-mode=swift -L .build/debug -I .build/debug -lDanger Dangerfile.swift fixtures/eidolon_609.json fixtures/response_data.json
    //
    // ## Run Danger Swift with a fixture'd JSON file
    // swift build; cat fixtures/eidolon_609.json  | ./.build/debug/danger-swift

    var args = [String]()
    args += ["--driver-mode=swift"] // Eval in swift mode, I think?
    args += ["-L", libDangerPath] // Find libs inside this folder
    args += ["-I", libDangerPath] // Find libs inside this folder
    args += ["-lDanger"] // Eval the code with the Target Danger added
    args += libArgs
    args += [dangerfilePath] // The Dangerfile
    args += [dslJSONPath] // The DSL for a Dangerfile from DangerJS
    args += [dangerResponsePath] // The expected for a Dangerfile from DangerJS
    args += Array(CommandLine.arguments.dropFirst())

    // This ain't optimal, but SwiftPM have _so much code_ around this.
    // So maybe there's a better way
    let supportedSwiftCPaths = ["/home/travis/.swiftenv/shims/swiftc", "/usr/bin/swiftc"]
    let swiftCPath = supportedSwiftCPaths.first { fileManager.fileExists(atPath: $0) }
    let swiftC = swiftCPath != nil ? swiftCPath! : "swiftc"

    logger.logInfo("Running: \(swiftC) \(args.joined(separator: " "))")

    // Create a process to eval the Swift file
    let proc = Process()
    proc.launchPath = swiftC
    proc.arguments = args

    let standardOutput = FileHandle.standardOutput
    proc.standardOutput = standardOutput
    proc.standardError = standardOutput

    proc.launch()
    proc.waitUntilExit()

    if (proc.terminationStatus != 0) {
        logger.logError("Dangerfile eval failed at \(dangerfilePath)")
    }

    // Pull out the results JSON that the Danger eval should generate
    guard let results = fileManager.contents(atPath: dangerResponsePath) else {
        logger.logError("Could not get the results JSON file at \(dangerResponsePath)")
        // Clean up after ourselves
        try? fileManager.removeItem(atPath: dslJSONPath)
        try? fileManager.removeItem(atPath: dangerResponsePath)
        exit(1)
    }

    // Take JSON and pipe it back to SDTOUT for DangerJS to read
    standardOutput.write(results)

    // Clean up after ourselves
    try? fileManager.removeItem(atPath: dslJSONPath)
    try? fileManager.removeItem(atPath: dangerResponsePath)

    // Return the same error code as the compilation
    exit(proc.terminationStatus)
}
