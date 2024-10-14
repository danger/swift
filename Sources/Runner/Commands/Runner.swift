import DangerDependenciesResolver
import DangerShellExecutor
import Foundation
import Logger
import RunnerLib

// swiftlint:disable:next function_body_length
func runDanger(version dangerSwiftVersion: String, logger: Logger) throws {
    // Pull in the JSON from Danger JS
    let standardInput = FileHandle.standardInput
    let fileManager = FileManager.default
    let tmpPath = NSTemporaryDirectory() + "danger/\(UUID().uuidString)/"
    let dangerResponsePath = tmpPath + "danger-response.json"

    try fileManager.createDirectory(
        at: URL(fileURLWithPath: tmpPath),
        withIntermediateDirectories: true
    )

    // Pull in the JSON from Danger JS
    guard let dangerDSLURL = String(data: standardInput.readDataToEndOfFile(), encoding: .utf8) else {
        logger.logError("Could get the Dangerfile DSL URL from STDing")
        exit(1)
    }
    // Extract the url from something like:
    //  danger://dsl//var/folders/gv/h3hr2l6102l0q6q5kn02kcnr0000gq/T/danger-dsl.json
    //
    let dslJSONPath = dangerDSLURL.components(separatedBy: "danger://dsl/").last!
    logger.debug("Got URL for JSON: \(dslJSONPath)")

    logger.debug("Created a temporary file for the Dangerfile DSL at: \(dslJSONPath)")

    // Pull our the JSON data so we can extract settings
    guard let dslJSONData = try? Data(contentsOf: URL(fileURLWithPath: dslJSONPath)) else {
        logger.logError("Invalid DSL JSON data",
                        "If you are running danger-swift by using danger command --process danger-swift " +
                            "please run danger-swift command instead",
                        separator: "\n")
        exit(1)
    }

    let parser = CliArgsParser()
    let cliArgs = parser.parseCli(fromData: dslJSONData)

    // Exit if a dangerfile was not found at any supported path
    guard let dangerfilePath = cliArgs?.dangerfile ?? Runtime.getDangerfile() else {
        logger.logError("Could not find a Dangerfile",
                        "Please use a supported path: \(Runtime.supportedPaths)",
                        separator: "\n")
        exit(1)
    }
    logger.debug("Running Dangerfile at: \(dangerfilePath)")

    var libArgs: [String] = []

    // Set up plugin infra
    let importsOnly = try String(contentsOfFile: dangerfilePath)
    let executor = ShellExecutor()

    if let spmDanger = SPMDanger() {
        spmDanger.buildDependencies(executor: executor)
        libArgs += ["-L", spmDanger.buildFolder]
        libArgs += ["-I", spmDanger.moduleFolder]
        libArgs += [spmDanger.swiftcLibImport]
    } else {
        guard let libDangerPath = Runtime.getLibDangerPath() else {
            let potentialFolders = Runtime.potentialLibraryFolders
            logger.logError("Could not find a libDanger to link against at any of: \(potentialFolders)",
                            "Or via Homebrew, or Marathon",
                            separator: "\n")
            exit(1)
        }

        libArgs += ["-L", libDangerPath] // Link to libDanger inside this folder
        libArgs += ["-I", libDangerPath] // Find libDanger inside this folder

        let importExternalDeps = importsOnly
            .components(separatedBy: .newlines)
            .filter { $0.hasPrefix("import") && $0.contains("package: ") }

        if !importExternalDeps.isEmpty {
            logger.logInfo("Cloning and building inline dependencies:",
                           "\(importExternalDeps.joined(separator: ", ")),",
                           "this might take some time.")

            let tempDangerfile = "_dangerfile_imports.swift"
            try importExternalDeps
                .joined(separator: "\n")
                .write(toFile: tempDangerfile, atomically: false, encoding: .utf8)

            defer { try? FileManager.default.removeItem(atPath: tempDangerfile) }

            let scriptManager = try getScriptManager(forDangerSwiftVersion: dangerSwiftVersion,
                                                     logger: logger)
            let script = try scriptManager.script(atPath: tempDangerfile)

            try script.build()
            let marathonPath = script.folder
            let artifactPaths = script.artifactsPath

            let marathonLibPath = artifactPaths
                .lazy
                .map { marathonPath + "/" + $0 }
                .filter(fileManager.fileExists)
                .first

            if let marathonLibPath {
                libArgs += ["-L", marathonLibPath]
                libArgs += ["-I", marathonLibPath]
                libArgs += ["-lDangerDependencies"]
            }
        }

        libArgs += ["-lDanger"] // Eval the code with the Target Danger added
    }

    logger.debug("Preparing to compile")
    let tempDangerfilePath = tmpPath + "_tmp_dangerfile.swift"

    let generator = DangerFileGenerator()
    try generator.generateDangerFile(fromContent: importsOnly, fileName: tempDangerfilePath, logger: logger)

    // Example commands:
    //
    //
    // ## Run the full system:
    // swift build;
    // env DANGER_GITHUB_API_TOKEN='MY_TOKEN' DANGER_FAKE_CI="YEP" DANGER_TEST_REPO='artsy/eigen' DANGER_TEST_PR='2408' danger process .build/debug/danger-swift --verbose --text-only
    //
    // ## Run compilation and eval of the Dangerfile:
    // swiftc --driver-mode=swift -L .build/debug -I .build/debug -lDanger Dangerfile.swift Fixtures/eidolon_609.json Fixtures/response_data.json
    //
    // ## Run Danger Swift with a fixture'd JSON file
    // swift build; cat Fixtures/eidolon_609.json  | ./.build/debug/danger-swift
    // swiftlint:enable line_length

    var args = [String]()
    args += ["--driver-mode=swift"] // Eval in swift mode, I think?
    args += libArgs
    args += [tempDangerfilePath] // The Dangerfile
    args += Array(CommandLine.arguments.dropFirst()) // Arguments sent to Danger
    args += [dslJSONPath] // The DSL for a Dangerfile from DangerJS
    args += [dangerResponsePath] // The expected for a Dangerfile from DangerJS

    #if os(macOS)
        let swiftC = try executor.spawn("xcrun", arguments: ["--find", "swift"])
    #else
        let swiftC = try executor.spawn("command", arguments: ["-v", "swift"])
    #endif

    logger.debug("Running: \(swiftC) \(args.joined(separator: " "))")

    // Create a process to eval the Swift file
    let proc = Process()
    proc.launchPath = swiftC
    proc.arguments = args
    let standardOutput = FileHandle.standardOutput
    if let cwdOptionIndex = CommandLine.arguments.firstIndex(of: DangeSwiftRunnerOption.cwd.rawValue),
       (cwdOptionIndex + 1) < CommandLine.arguments.count,
       let directoryURL = URL(string: CommandLine.arguments[cwdOptionIndex + 1])
    {
        proc.currentDirectoryPath = directoryURL.absoluteString
    }
    proc.standardOutput = standardOutput
    proc.standardError = standardOutput

    proc.launch()
    proc.waitUntilExit()

    logger.debug("Completed evaluation")

    if proc.terminationStatus != 0 {
        logger.logError("Dangerfile eval failed at \(dangerfilePath)")
    }

    // Pull out the results JSON that the Danger eval should generate
    guard fileManager.contents(atPath: dangerResponsePath) != nil else {
        logger.logError("Could not get the results JSON file at \(dangerResponsePath)")
        // Clean up after ourselves
        try? fileManager.removeItem(atPath: dslJSONPath)
        try? fileManager.removeItem(atPath: tmpPath)
        exit(1)
    }

    // Support the upcoming danger results-url
    standardOutput.write(Data("danger-results:/\(dangerResponsePath)\n\n".utf8))
    logger.debug("Saving and storing the results at \(dangerResponsePath)")

    // Clean up after ourselves
    try? fileManager.removeItem(atPath: dslJSONPath)
    try? fileManager.removeItem(atPath: tempDangerfilePath)

    // Return the same error code as the compilation
    exit(proc.terminationStatus)
}
