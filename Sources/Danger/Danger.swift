import Foundation

#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

// MARK: - DangerRunner

private final class DangerRunner {
    let version = "0.0.2"

    static let shared = DangerRunner()

    let dsl: DangerDSL
    var results = DangerResults()

    private init() {
        let dslJSONArg: String? = CommandLine.arguments[1]
        let outputJSONPath = CommandLine.arguments[2]

        guard let dslJSONPath = dslJSONArg else {
            print("could not find DSL JSON arg")
            exit(1)
        }

        guard let dslJSONContents = FileManager.default.contents(atPath: dslJSONPath) else {
            print("could not find DSL JSON at path: \(dslJSONPath)")
            exit(1)
        }

        do {
            let decoder = JSONDecoder()
            dsl = try decoder.decode(DangerDSL.self, from: dslJSONContents)

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
