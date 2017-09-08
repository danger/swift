import Foundation

#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

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

// Example command
// swiftc --driver-mode=swift -L .build/debug -I .build/debug -lDanger Dangerfile.swift fixtures/eidolon_609.json fixtures/response_data.json

var args = [String]()
args += ["--driver-mode=swift"] // Eval in swift mode, I think?
args += ["-L", ".build/debug"] // Find libs inside this folder (may need to change in production)
args += ["-I", ".build/debug"] // Find libs inside this folder (may need to change in production)
args += ["-lDanger"] // Eval the code with the Target Danger added
args += [dangerfilePath] // The Dangerfile
args += [dslJSONPath] // The DSL for a Dangerfile from DangerJS
args += [dangerResponsePath] // The expected for a Dangerfile from DangerJS

// This ain't optimal, but SwiftPM have _so much code_ around this.
// So maybe there's a better way
let supportedSwiftCPaths = ["/home/travis/.swiftenv/shims/swiftc", "/usr/bin/swiftc"]
let swiftCPath = supportedSwiftCPaths.first { fileManager.fileExists(atPath: $0) }
let swiftC = swiftCPath != nil ? swiftCPath! : "swiftc"

print("Running: \(swiftC) - \(args.joined(separator: " "))")

// Create a process to eval the Swift file
let proc = Process()
proc.launchPath = swiftC
proc.arguments = args
proc.launch()

let standardOutput = FileHandle.standardOutput

proc.standardOutput = standardOutput
proc.standardError = standardOutput
//
//    let data = stdOutPipe.fileHandleForReading.readDataToEndOfFile()
//    if let string = String(data: data, encoding: String.Encoding.utf8) {
//       print("## STD OUT:\n")
//       print(string)
//    }
//
//    let errData = stdErrPipe.fileHandleForReading.readDataToEndOfFile()
//    if let string = String(data: errData, encoding: String.Encoding.utf8) {
//       print("## STD ERR:\n")
//       print(string)
//    }

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
