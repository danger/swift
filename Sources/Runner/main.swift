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
fileManager.createFile(atPath: dslJSONPath, contents: input, attributes: nil)

// Example command
// swiftc --driver-mode=swift -L .build/debug -I .build/debug -lDanger Dangerfile.swift fixtures/eidolon_609.json fixtures/response_data.json

var args = [String]()
args += ["--driver-mode=swift"] // Eval in swift mode, I think?
args += ["-L", ".build/debug"] // Find libs inside this folder (may need to change in production)
args += ["-I", ".build/debug"] // Find libs inside this folder (may need to change in production)
args += ["-lDanger"] // Eval the code with the Target Danger added
args += ["Dangerfile.swift"] // The Dangerfile
args += [dslJSONPath] // The DSL for a Dangerfile from DangerJS
args += [dangerResponsePath] // The expected for a Dangerfile from DangerJS

// Create a process to eval the Swift file
let proc = Process()
proc.launchPath = "/usr/bin/swiftc"
proc.arguments = args
proc.launch()
proc.waitUntilExit()

// Pull out the results JSON that the Danger eval should generate
guard let results = fileManager.contents(atPath: dangerResponsePath) else {
    print("Could not get the results JSON file")
    exit(1)
}

// Take JSON and pipe it back to SDTOUT for DangerJS to read
let standardOutput = FileHandle.standardOutput
standardOutput.write(results)

// Clean up after ourselves
try? fileManager.removeItem(atPath: dslJSONPath)
try? fileManager.removeItem(atPath: dangerResponsePath)
