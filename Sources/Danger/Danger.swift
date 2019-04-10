import Foundation

#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif
import Logger

public let runner = DangerRunner()

public var danger: DangerDSL {
    return runner.dsl
}

// MARK: - DangerRunner

public final class DangerRunner {
    let logger: Logger
    public let dsl: DangerDSL
    var results = DangerResults()

    public init() {
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
            let decoder = JSONDecoder()
            if #available(OSX 10.12, *) {
                decoder.dateDecodingStrategy = .iso8601
            } else {
                decoder.dateDecodingStrategy = .formatted(DateFormatter.defaultDateFormatter)
            }
            logger.debug("Decoding the DSL into Swift types")
            dsl = try decoder.decode(DSL.self, from: dslJSONContents).danger

        } catch {
            logger.logError("Failed to parse JSON:", error)
            exit(1)
        }

        logger.debug("Setting up to dump results")
        dumpResultsAtExit(self, path: outputJSONPath)
    }
}

// MARK: - Public Functions

public func Danger() -> DangerDSL {
    return danger
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

        } catch {
            dumpInfo.danger.logger.logError("Failed to generate result JSON:", error)
            exit(1)
        }
    }
    dumpInfo = (runner, path)
    atexit(dump)
}
