import Foundation

#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif
import Logger

// MARK: - DangerRunner

final class DangerRunner {
    static let shared = DangerRunner()

    let logger: Logger
    let dsl: DangerDSL
    let outputPath: String
    var results = DangerResults() {
        didSet {
            dumpResults()
        }
    }

    private init() {
        let isVerbose = CommandLine.arguments.contains("--verbose")
            || (ProcessInfo.processInfo.environment["DEBUG"] != nil)
        let isSilent = CommandLine.arguments.contains("--silent")
        logger = Logger(isVerbose: isVerbose, isSilent: isSilent)
        logger.debug("Ran with: \(CommandLine.arguments.joined(separator: " "))")

        let cliLength = CommandLine.arguments.count

        guard cliLength - 2 > 0 else {
            logger.logError("To execute Danger run danger-swift ci, " +
                "danger-swift pr or danger-swift local on your terminal")
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
            decoder.dateDecodingStrategy = .custom(DateFormatter.dateFormatterHandler)
            logger.debug("Decoding the DSL into Swift types")
            dsl = try decoder.decode(DSL.self, from: dslJSONContents).danger
        } catch {
            logger.logError("Failed to parse JSON:", error)
            exit(1)
        }

        logger.debug("Setting up to dump results")
        outputPath = outputJSONPath
        dumpResults()
    }

    private func dumpResults() {
        logger.debug("Sending results back to Danger")
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(results)

            if !FileManager.default.createFile(atPath: outputPath,
                                               contents: data,
                                               attributes: nil)
            {
                logger.logError("Could not create a temporary file " +
                    "for the Dangerfile DSL at: \(outputPath)")
                exit(0)
            }

        } catch {
            logger.logError("Failed to generate result JSON:", error)
            exit(1)
        }
    }
}

// MARK: - Public Functions

// swiftlint:disable:next identifier_name
public func Danger() -> DangerDSL {
    DangerRunner.shared.dsl
}
