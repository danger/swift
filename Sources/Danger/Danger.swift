import Foundation

#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

// MARK: - DangerRunner

private final class DangerRunner {
    let version = "0.3.0"

    static let shared = DangerRunner()

    let dsl: DangerDSL
    var results = DangerResults()

    private init() {
        print("Ran with: \(CommandLine.arguments.joined(separator: " "))")

        let cliLength = CommandLine.arguments.count
        let dslJSONArg: String? = CommandLine.arguments[cliLength - 2]
        let outputJSONPath = CommandLine.arguments[cliLength - 1]

        guard let dslJSONPath = dslJSONArg else {
            print("could not find DSL JSON arg")
            exit(1)
        }

        guard var dslJSONContents = FileManager.default.contents(atPath: dslJSONPath) else {
            print("could not find DSL JSON at path: \(dslJSONPath)")
            exit(1)
        }

        do {
            let decoder = JSONDecoder()
            stripToplevelObject(&dslJSONContents)
            dsl = try decoder.decode(DSL.self, from: dslJSONContents).danger

        } catch let error {
            print("Failed to parse JSON:")
            print(error)
            exit(1)
        }

        dumpResultsAtExit(self, path: outputJSONPath)
    }
}

// MARK: - Public Functions

public func Danger() -> DangerDSL {
    return DangerRunner.shared.dsl
}

/// Adds a warning message to the Danger report
///
/// - Parameter message: A markdown-ish
public func warn(_ message: String) {
    DangerRunner.shared.results.warnings.append(Violation(message: message))
}

/// Adds a warning message to the Danger report
///
/// - Parameter message: A markdown-ish
public func fail(_ message: String) {
    DangerRunner.shared.results.fails.append(Violation(message: message))
}

/// Adds a warning message to the Danger report
///
/// - Parameter message: A markdown-ish
public func message(_ message: String) {
    DangerRunner.shared.results.messages.append(Violation(message: message))
}

/// Adds a warning message to the Danger report
///
/// - Parameter message: A markdown-ish
public func markdown(_ message: String) {
    DangerRunner.shared.results.markdowns.append(message)
}

// MARK: - Private Functions

private func stripToplevelObject(_ data: inout Data) {

    var seenOpenBracket = false

    while let byte = data.first {
        // { == 123
        if byte == 123 {
            if !seenOpenBracket {
                seenOpenBracket = true
                data.removeFirst()
                continue
            } else {
                break
            }
        }
        data.removeFirst()
    }

    while let byte = data.last {
        // } == 125
        if byte == 125 {
            data.removeLast()
            break
        }
        data.removeLast()
    }
}

private var dumpInfo: (danger: DangerRunner, path: String)?

private func dumpResultsAtExit(_ runner: DangerRunner, path: String) {
    func dump() {
        guard let dumpInfo = dumpInfo else { return }
        print("Sending results back to Danger")
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(dumpInfo.danger.results)

            if !FileManager.default.createFile(atPath: dumpInfo.path, contents: data, attributes: nil) {
                print("Could not create a temporary file for the Dangerfile DSL at: \(dumpInfo.path)")
                exit(0)
            }

        } catch let error {
            print("Failed to generate result JSON:")
            print(error)
            exit(1)
        }

    }
    dumpInfo = (runner, path)
    atexit(dump)
}
