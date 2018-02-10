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

    let logger: Logger
    let dsl: DangerDSL
    var results = DangerResults()

    private init() {
        let isVerbose = CommandLine.arguments.contains("--verbose")
        let isSilent = CommandLine.arguments.contains("--silent")
        logger = Logger(isVerbose: isVerbose, isSilent: isSilent)
        logger.logInfo("Ran with: \(CommandLine.arguments.joined(separator: " "))")
        
        let cliLength = CommandLine.arguments.count
        let dslJSONArg: String? = CommandLine.arguments[cliLength - 2]
        let outputJSONPath = CommandLine.arguments[cliLength - 1]

        guard let dslJSONPath = dslJSONArg else {
            logger.logError("could not find DSL JSON arg")
            exit(1)
        }

        guard let dslJSONContents = FileManager.default.contents(atPath: dslJSONPath) else {
            logger.logError("could not find DSL JSON at path: \(dslJSONPath)")
            exit(1)
        }
        do {
            let string = String(data: dslJSONContents, encoding: .utf8)
            logger.logInfo(string!, isVerbose: true)

            let decoder = JSONDecoder()
            if #available(OSX 10.12, *) {
                decoder.dateDecodingStrategy = .iso8601
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
            }
            dsl = try decoder.decode(DSL.self, from: dslJSONContents).danger

        } catch let error {
            logger.logError("Failed to parse JSON:", error)
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
        dumpInfo.danger.logger.logInfo("Sending results back to Danger")
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(dumpInfo.danger.results)

            if !FileManager.default.createFile(atPath: dumpInfo.path, contents: data, attributes: nil) {
                dumpInfo.danger.logger.logError("Could not create a temporary file for the Dangerfile DSL at: \(dumpInfo.path)")
                exit(0)
            }

        } catch let error {
            dumpInfo.danger.logger.logError("Failed to generate result JSON:", error)
            exit(1)
        }

    }
    dumpInfo = (runner, path)
    atexit(dump)
}
