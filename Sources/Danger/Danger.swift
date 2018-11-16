import Foundation

#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif
import Logger

// MARK: - DangerRunner

private final class DangerRunner {
    static let shared = DangerRunner()

    let logger: Logger
    let dsl: DangerDSL
    var results = DangerResults()

    private init() {
        let isVerbose = CommandLine.arguments.contains("--verbose") || (ProcessInfo.processInfo.environment["DEBUG"] != nil)
        let isSilent = CommandLine.arguments.contains("--silent")
        logger = Logger(isVerbose: isVerbose, isSilent: isSilent)
        logger.debug("Ran with: \(CommandLine.arguments.joined(separator: " "))")
        
        let cliLength = CommandLine.arguments.count
        
        guard cliLength - 2 > 0 else {
            logger.logError("To execute Danger run danger-swift ci , danger-swift pr or danger-swift local on your terminal")
            exit(1)
        }
        
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
            logger.debug(string!)

            let decoder = JSONDecoder()
            if #available(OSX 10.12, *) {
                decoder.dateDecodingStrategy = .iso8601
            } else {
                decoder.dateDecodingStrategy = .formatted(DateFormatter.defaultDateFormatter)
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

extension DangerDSL {
    /// Fails on the Danger report
    public var fails: [Violation] {
        return DangerRunner.shared.results.fails
    }
    
    /// Warnings on the Danger report
    public var warnings: [Violation] {
        return DangerRunner.shared.results.warnings
    }
    
    /// Messages on the Danger report
    public var messages: [Violation] {
        return DangerRunner.shared.results.messages
    }
    
    /// Markdowns on the Danger report
    public var markdowns: [Violation] {
        return DangerRunner.shared.results.markdowns
    }
    
    /// Adds a warning message to the Danger report
    ///
    /// - Parameter message: A markdown-ish
    public func warn(_ message: String) {
        DangerRunner.shared.results.warnings.append(Violation(message: message))
    }
    
    /// Adds an inline warning message to the Danger report
    public func warn(message: String, file: String, line: Int) {
        DangerRunner.shared.results.warnings.append(Violation(message: message, file: file, line: line))
    }
    
    /// Adds a warning message to the Danger report
    ///
    /// - Parameter message: A markdown-ish
    public func fail(_ message: String) {
        DangerRunner.shared.results.fails.append(Violation(message: message))
    }
    
    /// Adds an inline fail message to the Danger report
    public func fail(message: String, file: String, line: Int) {
        DangerRunner.shared.results.fails.append(Violation(message: message, file: file, line: line))
    }
    
    /// Adds a warning message to the Danger report
    ///
    /// - Parameter message: A markdown-ish
    public func message(_ message: String) {
        DangerRunner.shared.results.messages.append(Violation(message: message))
    }
    
    /// Adds an inline message to the Danger report
    public func message(message: String, file: String, line: Int) {
        DangerRunner.shared.results.messages.append(Violation(message: message, file: file, line: line))
    }
    
    /// Adds a warning message to the Danger report
    ///
    /// - Parameter message: A markdown-ish
    public func markdown(_ message: String) {
        DangerRunner.shared.results.markdowns.append(Violation(message: message))
    }
    
    /// Adds an inline message to the Danger report
    public func markdown(message: String, file: String, line: Int) {
        DangerRunner.shared.results.markdowns.append(Violation(message: message, file: file, line: line))
    }
}

/// Fails on the Danger report
public var fails: [Violation] {
    return DangerRunner.shared.dsl.fails
}

/// Warnings on the Danger report
public var warnings: [Violation] {
    return DangerRunner.shared.dsl.warnings
}

/// Messages on the Danger report
public var messages: [Violation] {
    return DangerRunner.shared.dsl.messages
}

/// Markdowns on the Danger report
public var markdowns: [Violation] {
    return DangerRunner.shared.dsl.markdowns
}

/// Adds a warning message to the Danger report
///
/// - Parameter message: A markdown-ish
public func warn(_ message: String) {
    DangerRunner.shared.dsl.warn(message)
}

/// Adds an inline warning message to the Danger report
public func warn(message: String, file: String, line: Int) {
    DangerRunner.shared.dsl.warn(message: message, file: file, line: line)
}

/// Adds a warning message to the Danger report
///
/// - Parameter message: A markdown-ish
public func fail(_ message: String) {
    DangerRunner.shared.dsl.fail(message)
}

/// Adds an inline fail message to the Danger report
public func fail(message: String, file: String, line: Int) {
    DangerRunner.shared.dsl.fail(message: message, file: file, line: line)
}

/// Adds a warning message to the Danger report
///
/// - Parameter message: A markdown-ish
public func message(_ message: String) {
    DangerRunner.shared.dsl.message(message)
}

/// Adds an inline message to the Danger report
public func message(message: String, file: String, line: Int) {
    DangerRunner.shared.dsl.message(message: message, file: file, line: line)
}

/// Adds a warning message to the Danger report
///
/// - Parameter message: A markdown-ish
public func markdown(_ message: String) {
    DangerRunner.shared.dsl.markdown(message)
}

/// Adds an inline message to the Danger report
public func markdown(message: String, file: String, line: Int) {
    DangerRunner.shared.dsl.markdown(message: message, file: file, line: line)
}

// MARK: - Private Functions

private var dumpInfo: (danger: DangerRunner, path: String)?

private func dumpResultsAtExit(_ runner: DangerRunner, path: String) {
    func dump() {
        guard let dumpInfo = dumpInfo else { return }
        dumpInfo.danger.logger.debug("Sending results back to Danger")
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
