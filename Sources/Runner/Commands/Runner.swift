import DangerDependenciesResolver
import Foundation
import Logger
import RunnerLib
import ShellRunner

// swiftlint:disable:next function_body_length
func runDanger(logger: Logger) throws {
    // Pull in the JSON from Danger JS
    let standardInput = FileHandle.standardInput
    let fileManager = FileManager.default
    let tmpPath = NSTemporaryDirectory()
    let dangerResponsePath = tmpPath + "danger-response.json"

    // Pull in the JSON from Danger JS
    guard let dangerDSLURL = String(data: standardInput.readDataToEndOfFile(), encoding: .utf8) else {
        logger.logError("Could get the Dangerfile DSL URL from STDing")
        exit(1)
    }
    // Extract the url from something like:
    //  danger://dsl//var/folders/gv/h3hr2l6102l0q6q5kn02kcnr0000gq/T/danger-dsl.json
    //
    let dslJsonPath = dangerDSLURL.components(separatedBy: "danger://dsl/").last!
    defer { try? fileManager.removeItem(atPath: dslJsonPath) }

    logger.debug("Got URL for JSON: \(dslJsonPath)")
    logger.debug("Created a temporary file for the Dangerfile DSL at: \(dslJsonPath)")

    // Pull our the JSON data so we can extract settings
    guard let dslJSONData = try? Data(contentsOf: URL(fileURLWithPath: dslJsonPath)) else {
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
    let shell = ShellRunner()

    if let spmDanger = SPMDanger() {
        spmDanger.buildDependencies(shell: shell)
        libArgs += ["-L", spmDanger.buildFolder]
        libArgs += ["-I", spmDanger.buildFolder]
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

            let scriptManager = try getScriptManager(logger)
            let script = try scriptManager.script(atPath: tempDangerfile)

            try script.build()
            let marathonPath = script.folder
            let artifactPaths = [".build/debug", ".build/release"]

            let marathonLibPath = artifactPaths
                .lazy
                .map { marathonPath + "/" + $0 }
                .filter(fileManager.fileExists)
                .first

            if marathonLibPath != nil {
                libArgs += ["-L", marathonLibPath!]
                libArgs += ["-I", marathonLibPath!]
                libArgs += ["-lDangerDependencies"]
            }
        }

        libArgs += ["-lDanger"] // Eval the code with the Target Danger added
    }

    logger.debug("Preparing to compile")

    let tempDangerfilePath = tmpPath + "_tmp_dangerfile.swift"
    let generator = DangerFileGenerator()
    try generator.generateDangerFile(fromContent: importsOnly, fileName: tempDangerfilePath, logger: logger)
    defer { try? fileManager.removeItem(atPath: tempDangerfilePath) }

    try evalDangerfile(
        dangerfilePath: dangerfilePath,
        libArgs: libArgs,
        tempDangerfilePath: tempDangerfilePath,
        dslJsonPath: dslJsonPath,
        dangerResponsePath: dangerResponsePath
    )

    guard fileManager.contents(atPath: dangerResponsePath) != nil else {
        logger.logError("Could not get the results JSON file at \(dangerResponsePath)")
        try? fileManager.removeItem(atPath: dangerResponsePath)
        exit(1)
    }

    // Support the upcoming danger results-url
    logger.logInfo(Data("danger-results:/\(dangerResponsePath)\n\n".utf8))
    logger.debug("Saving and storing the results at \(dangerResponsePath)")
}

/// # Example commands
///
/// ## Run the full system
///
///     swift build;
///     env DANGER_GITHUB_API_TOKEN='MY_TOKEN' DANGER_FAKE_CI="YEP" DANGER_TEST_REPO='artsy/eigen' DANGER_TEST_PR='2408' danger process .build/debug/danger-swift --verbose --text-only
///
/// ## Run compilation and eval of the Dangerfile
///
///     swiftc --driver-mode=swift -L .build/debug -I .build/debug -lDanger Dangerfile.swift Fixtures/eidolon_609.json Fixtures/response_data.json
///
/// ## Run Danger Swift with a fixture'd JSON file
///
///     swift build; cat Fixtures/eidolon_609.json  | ./.build/debug/danger-swift
private func evalDangerfile(
    dangerfilePath: String,
    libArgs: [String],
    tempDangerfilePath: String,
    dslJsonPath: String,
    dangerResponsePath: String,
    shell: ShellRunnerProtocol = ShellRunner()
) throws {
    var arguments = [String]()
    arguments += ["--driver-mode=swift"]
    arguments += libArgs
    arguments += [tempDangerfilePath]
    arguments += Array(CommandLine.arguments.dropFirst())
    arguments += [dslJsonPath] // The DSL for a Dangerfile from DangerJS
    arguments += [dangerResponsePath] // The expected response for a Dangerfile from DangerJS

    let swiftC = try shell.run("command -v swiftc")

    logger.debug("Running: \(swiftC) \(arguments.joined(separator: " "))")

    let process = Process()
    process.arguments = arguments

    let standardOutput = FileHandle.standardOutput
    process.standardOutput = standardOutput
    process.standardError = standardOutput

    if let cwdOptionIndex = CommandLine.arguments.firstIndex(of: DangeSwiftRunnerOption.cwd.rawValue),
       (cwdOptionIndex + 1) < CommandLine.arguments.count,
       let currentDirectoryURL = URL(string: CommandLine.arguments[cwdOptionIndex + 1]
    ) {
        if #available(macOS 10.13, *) {
            process.currentDirectoryURL = currentDirectoryURL
        } else {
            process.currentDirectoryPath = currentDirectoryURL.absoluteString
        }
    }

    if #available(macOS 10.13, *) {
        process.executableURL = URL(fileURLWithPath: swiftC)
        try process.run()
    } else {
        process.launchPath = swiftC
        process.launch()
    }

    process.waitUntilExit()

    if process.terminationStatus == 0 {
        logger.debug("Completed evaluation")
    } else {
        logger.logError("Dangerfile eval failed at \(dangerfilePath)")
    }
}
