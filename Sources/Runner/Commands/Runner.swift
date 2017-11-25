import Foundation

func runDanger() -> Void {
    // Pull in the JSON from Danger JS
    let standardInput = FileHandle.standardInput
    let input = standardInput.readDataToEndOfFile()

    // Set up some example paths for us to work with
    let path = NSTemporaryDirectory()
    let dslJSONPath = path + "danger-dsl.json"
    let dangerResponsePath = path + "danger-response.json"

    let fileManager = FileManager.default

    // Create the DSL JSON file for the the runner to read from
    if !fileManager.createFile(atPath: dslJSONPath, contents: input, attributes: nil) {
        print("Could not create a temporary file for the Dangerfile DSL at: \(dslJSONPath)")
        exit(0)
    }

    // Finds first occurrence of supported path
    let supportedPaths = ["Dangerfile.swift", "danger/Dangerfile.swift", "Danger/Dangerfile.swift"]
    let resolvedPath = supportedPaths.first { fileManager.fileExists(atPath: $0) }

    // Exit if a dangerfile was not found at any supported path
    guard let dangerfilePath = resolvedPath else {
        print("Could not find a Dangerfile")
        print("Please use a supported path: \(supportedPaths)")
        exit(0)
    }

    // Is this a dev build: e.g. running inside a cloned danger/danger-swift
    let libraryFolders = [
        ".build/debug", // Working in Xcode / CLI
        ".build/x86_64-unknown-linux/debug", // Danger Swift's CI
        ".build/release", // Testing prod
        "/usr/local/lib/danger" // Homebrew installs lib stuff to here
    ]

    // for testing prod, do a `make install` first
    //let libraryFolders = ["/usr/local/lib/danger"]

    // Was danger-swift installed via marathon?
    // e.g "~/.marathon/Scripts/Temp/https:--github.com-danger-danger-swift.git/clone/.build/release"
    let marathonDangerDLDir = NSHomeDirectory() + "/.marathon/Scripts/Temp/"
    let marathonScripts = try? fileManager.contentsOfDirectory(atPath: marathonDangerDLDir)
    var depManagerDangerLibPaths: [String] = []

    if marathonScripts != nil {
        // TODO: Support running from a fork?
        let dangerSwiftPath = marathonScripts!.first { return $0.contains("danger-swift") }
        if dangerSwiftPath != nil {
            let path = marathonDangerDLDir + dangerSwiftPath! + "/clone/.build/release"
            depManagerDangerLibPaths.append(path)
        }
    }

    // Check and find where we can link to libDanger from
    let libDanger = "libDanger.dylib"
    let libPaths = libraryFolders + depManagerDangerLibPaths


    func isTheDangerLibPath(path: String) -> Bool {
        return fileManager.fileExists(atPath: path + "/libDanger.dylib")  || // OSX
               fileManager.fileExists(atPath: path + "/libDanger.so")        // Linux
    }

    guard let libPath = libPaths.first(where: isTheDangerLibPath) else {
        print("Could not find a libDanger at any of: \(libPaths)")
        exit(1)
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
    args += ["-L", libPath] // Find libs inside this folder
    args += ["-I", libPath] // Find libs inside this folder
    args += ["-lDanger"] // Eval the code with the Target Danger added
    args += [dangerfilePath] // The Dangerfile
    args += [dslJSONPath] // The DSL for a Dangerfile from DangerJS
    args += [dangerResponsePath] // The expected for a Dangerfile from DangerJS

    // This ain't optimal, but SwiftPM have _so much code_ around this.
    // So maybe there's a better way
    let supportedSwiftCPaths = ["/home/travis/.swiftenv/shims/swiftc", "/usr/bin/swiftc"]
    let swiftCPath = supportedSwiftCPaths.first { fileManager.fileExists(atPath: $0) }
    let swiftC = swiftCPath != nil ? swiftCPath! : "swiftc"

    print("Running: \(swiftC) \(args.joined(separator: " "))")

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
        print("Dangerfile eval failed at \(dangerfilePath)")
    }

    // Pull out the results JSON that the Danger eval should generate
    guard let results = fileManager.contents(atPath: dangerResponsePath) else {
        print("Could not get the results JSON file at \(dangerResponsePath)")
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
