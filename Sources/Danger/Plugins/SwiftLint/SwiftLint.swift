import DangerShellExecutor
import Foundation

/// The SwiftLint plugin has been embedded inside Danger, making
/// it usable out of the box.
public enum SwiftLint {
    public typealias FilesFilter = ((_ file: File) -> Bool)

    static let danger = Danger()
    static let shellExecutor = ShellExecutor()

    /// This is the main entry point for linting Swift in PRs.
    ///
    /// When the swiftlintPath is not specified,
    /// it uses by default swift run swiftlint if the Package.swift contains swiftlint as dependency,
    /// otherwise calls directly the swiftlint command

    @discardableResult
    public static func lint(inline: Bool = false,
                            directory: String? = nil,
                            configFile: String? = nil,
                            strict: Bool = false,
                            quiet: Bool = true,
                            lintAllFiles: Bool = false,
                            filesFilter: FilesFilter? = nil,
                            swiftlintPath: String? = nil) -> [SwiftLintViolation] {
        lint(danger: danger,
             shellExecutor: shellExecutor,
             swiftlintPath: swiftlintPath ?? SwiftLint.swiftlintDefaultPath(),
             inline: inline,
             directory: directory,
             configFile: configFile,
             strict: strict,
             quiet: quiet,
             lintAllFiles: lintAllFiles,
             filesFilter: filesFilter)
    }
}

/// This extension is for internal workings of the plugin. It is marked as internal for unit testing.
extension SwiftLint {
    // swiftlint:disable:next function_body_length
    static func lint(
        danger: DangerDSL,
        shellExecutor: ShellExecuting,
        swiftlintPath: String,
        inline: Bool = false,
        directory: String? = nil,
        configFile: String? = nil,
        strict: Bool = false,
        quiet: Bool = true,
        lintAllFiles: Bool = false,
        filesFilter: FilesFilter? = nil,
        currentPathProvider: CurrentPathProvider = DefaultCurrentPathProvider(),
        outputFilePath: String = tmpSwiftlintOutputFilePath,
        reportDeleter: SwiftlintReportDeleting = SwiftlintReportDeleter(),
        markdownAction: (String) -> Void = markdown,
        failAction: (String) -> Void = fail,
        failInlineAction: (String, String, Int) -> Void = fail,
        warnInlineAction: (String, String, Int) -> Void = warn,
        readFile: (String) -> String = danger.utils.readFile
    ) -> [SwiftLintViolation] {

        if filesFilter != nil && lintAllFiles {
            failAction("You can't use a files filter when lintAllFiles is set to `true`.")
            return []
        }

        var arguments = ["lint", "--reporter json"]

        if quiet {
            arguments.append("--quiet")
        }

        if let configFile = configFile {
            arguments.append("--config \"\(configFile)\"")
        }

        defer {
            try? reportDeleter.deleteReport(atPath: outputFilePath)
        }

        var violations: [SwiftLintViolation]
        if lintAllFiles {
            // Allow folks to lint all the potential files
            violations = lintAll(directory: directory,
                                 arguments: arguments,
                                 shellExecutor: shellExecutor,
                                 swiftlintPath: swiftlintPath,
                                 outputFilePath: outputFilePath,
                                 failAction: failAction,
                                 readFile: readFile)
        } else {
            violations = lintModifiedAndCreated(danger: danger,
                                                directory: directory,
                                                filesFilter: filesFilter,
                                                arguments: arguments,
                                                shellExecutor: shellExecutor,
                                                swiftlintPath: swiftlintPath,
                                                outputFilePath: outputFilePath,
                                                failAction: failAction,
                                                readFile: readFile)
        }

        guard !violations.isEmpty else {
            return []
        }

        let currentPath = currentPathProvider.currentPath
        violations = violations.map { violation in
            var violation = violation

            let updatedPath = violation.file.deletingPrefix(currentPath).deletingPrefix("/")
            violation.file = updatedPath

            if strict {
                violation.severity = .error
            }
            return violation
        }

        if inline {
            violations.forEach { violation in
                switch violation.severity {
                case .error:
                    failInlineAction(violation.messageText, violation.file, violation.line)
                case .warning:
                    warnInlineAction(violation.messageText, violation.file, violation.line)
                }
            }
        } else {
            var markdownMessage = """
            ### SwiftLint found issues

            | Severity | File | Reason |
            | -------- | ---- | ------ |\n
            """
            markdownMessage += violations.map { $0.toMarkdown() }.joined(separator: "\n")
            markdownAction(markdownMessage)
        }

        return violations
    }

    // swiftlint:disable:next function_parameter_count
    private static func lintAll(directory: String?,
                                arguments: [String],
                                shellExecutor: ShellExecuting,
                                swiftlintPath: String,
                                outputFilePath: String,
                                failAction: (String) -> Void,
                                readFile: (String) -> String) -> [SwiftLintViolation] {
        var arguments = arguments

        if let directory = directory {
            arguments.append("--path \"\(directory)\"")
        }

        return swiftlintViolations(swiftlintPath: swiftlintPath,
                                   arguments: arguments,
                                   environmentVariables: [:],
                                   outputFilePath: outputFilePath,
                                   shellExecutor: shellExecutor,
                                   failAction: failAction,
                                   readFile: readFile)
    }

    // swiftlint:disable function_parameter_count
    private static func lintModifiedAndCreated(danger: DangerDSL,
                                               directory: String?,
                                               filesFilter: FilesFilter?,
                                               arguments: [String],
                                               shellExecutor: ShellExecuting,
                                               swiftlintPath: String,
                                               outputFilePath: String,
                                               failAction: (String) -> Void,
                                               readFile: (String) -> String) -> [SwiftLintViolation] {
        // Gathers modified+created files, invokes SwiftLint on each, and posts collected errors+warnings to Danger.
        var files = (danger.git.createdFiles + danger.git.modifiedFiles).filter { $0.fileType == .swift }
        if let directory = directory {
            files = files.filter { $0.hasPrefix(directory) }
        }

        if let filesFilter = filesFilter {
            files = files.filter(filesFilter)
        }

        // Only run Swiftlint, if there are files to lint
        guard !files.isEmpty else {
            return []
        }

        var arguments = arguments
        arguments.append("--use-script-input-files")
        arguments.append("--force-exclude")

        // swiftlint takes input files via environment variables
        var inputFiles = ["SCRIPT_INPUT_FILE_COUNT": "\(files.count)"]
        for (index, file) in files.enumerated() {
            inputFiles["SCRIPT_INPUT_FILE_\(index)"] = file
        }

        return swiftlintViolations(swiftlintPath: swiftlintPath,
                                   arguments: arguments,
                                   environmentVariables: inputFiles,
                                   outputFilePath: outputFilePath,
                                   shellExecutor: shellExecutor,
                                   failAction: failAction,
                                   readFile: readFile)
    }

    static func swiftlintDefaultPath(packagePath: String = "Package.swift") -> String {
        let swiftPackageDepPattern = "\\.package\\(.*SwiftLint.*"
        if let packageContent = try? String(contentsOfFile: packagePath),
            let regex = try? NSRegularExpression(pattern: swiftPackageDepPattern, options: .allowCommentsAndWhitespace),
            regex.firstMatchingString(in: packageContent) != nil {
            return "swift run swiftlint"
        } else {
            return "swiftlint"
        }
    }

    private static func swiftlintViolations(swiftlintPath: String,
                                            arguments: [String],
                                            environmentVariables: [String: String],
                                            outputFilePath: String,
                                            shellExecutor: ShellExecuting,
                                            failAction: (String) -> Void,
                                            readFile: (String) -> String) -> [SwiftLintViolation] {
        shellExecutor.execute(swiftlintPath,
                              arguments: arguments,
                              environmentVariables: environmentVariables,
                              outputFile: outputFilePath)

        let outputJSON = readFile(outputFilePath)
        return makeViolations(from: outputJSON, failAction: failAction)
    }

    private static func makeViolations(from response: String, failAction: (String) -> Void) -> [SwiftLintViolation] {
        let decoder = JSONDecoder()
        do {
            let violations = try decoder.decode([SwiftLintViolation].self, from: response.data(using: .utf8)!)
            return violations
        } catch {
            failAction("Error deserializing SwiftLint JSON response (\(response)): \(error)")
            return []
        }
    }

    private static var tmpSwiftlintOutputFilePath: String {
        if #available(OSX 10.12, *) {
            return FileManager.default.temporaryDirectory.appendingPathComponent("swiftlintReport.json").path
        } else {
            return NSTemporaryDirectory() + "swiftlintReport.json"
        }
    }
}

private extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }
        return String(dropFirst(prefix.count))
    }
}
