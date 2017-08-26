import Foundation

#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

struct Results: Codable {
    var fails = [Violation]()
    var warnings = [Violation]()
    var messages = [Violation]()
    var markdowns = [String]()
}

struct Violation: Codable {
    let message: String
}

private final class DangerRunner {
    static let shared = DangerRunner()

    let dsl: DangerDSL
    var results = Results()

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


private var dumpInfo: (danger: DangerRunner, path: String)?
private func dumpResultsAtExit(_ runner: DangerRunner, path: String) {
    func dump() {
        guard let dumpInfo = dumpInfo else { return }
        print("Sending results back to Danger")
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(dumpInfo.danger.results)
//          print(String(data: data, encoding: .utf8)!)

            FileManager.default.createFile(atPath: dumpInfo.path, contents: data, attributes: nil)

        } catch let error {
            print("Failed to generate result JSON:")
            print(error)
            exit(1)
        }

    }
    dumpInfo = (runner, path)
    atexit(dump)
}
