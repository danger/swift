import DangerShellExecutor
import Foundation

/// The SwiftLint plugin has been embedded inside Danger, making
/// it usable out of the box.
public enum SwiftLint {
    public enum LintStyle {
        /// Lints all the files instead of only the modified and created files.
        /// - Parameters:
        ///   - directory: Optional property to set the --path to execute at.
        case all(directory: String?)

        /// Only lints the modified and created files with `.swift` extension.
        /// - Parameters:
        ///   - directory: Optional property to set the --path to execute at.
        case modifiedAndCreatedFiles(directory: String?)

        /// Lints only the given files. This can be useful to do some manual filtering.
        /// The files will be filtered on `.swift` only.
        case files([File])
    }

    static let danger = Danger()
    static let shellExecutor = ShellExecutor()

    /// This method is deprecated in favor of
    @available(*, deprecated, message: "Use the lint(_ lintStyle ..) method instead.")
    @discardableResult
    public static func lint(inline: Bool = false,
                            directory: String? = nil,
                            configFile: String? = nil,
                            strict: Bool = false,
                            quiet: Bool = true,
                            lintAllFiles: Bool = false,
                            swiftlintPath: String? = nil) -> [SwiftLintViolation] {
        let lintStyle: LintStyle = lintAllFiles ? .all(directory: directory) : .modifiedAndCreatedFiles(directory: directory)
        return lint(lintStyle,
                    inline: inline,
                    configFile: configFile,
                    strict: strict,
                    quiet: quiet,
                    lintAllFiles: lintAllFiles,
                    swiftlintPath: swiftlintPath)
    }

    /// This is the main entry point for linting Swift in PRs.
    ///
    /// When the swiftlintPath is not specified,
    /// it uses by default swift run swiftlint if the Package.swift contains swiftlint as dependency,
    /// otherwise calls directly the swiftlint command
    @discardableResult
    public static func lint(_ lintStyle: LintStyle = .modifiedAndCreatedFiles(directory: nil),
                            inline: Bool = false,
                            configFile: String? = nil,
                            strict: Bool = false,
                            quiet: Bool = true,
                            lintAllFiles: Bool = false,
                            swiftlintPath: String? = nil) -> [SwiftLintViolation] {
        lint(lintStyle: lintStyle,
             danger: danger,
             shellExecutor: shellExecutor,
             swiftlintPath: swiftlintPath ?? SwiftLint.swiftlintDefaultPath(),
             inline: inline,
             configFile: configFile,
             strict: strict,
             quiet: quiet)
    }
}

/// This extension is for internal workings of the plugin. It is marked as internal for unit testing.
extension SwiftLint {
    // swiftlint:disable:next function_body_length
    static func lint(
        lintStyle: LintStyle = .modifiedAndCreatedFiles(directory: nil),
        danger: DangerDSL,
        shellExecutor: ShellExecuting,
        swiftlintPath: String,
        inline: Bool = false,
        configFile: String? = nil,
        strict: Bool = false,
        quiet: Bool = true,
        currentPathProvider: CurrentPathProvider = DefaultCurrentPathProvider(),
        outputFilePath: String = tmpSwiftlintOutputFilePath,
        reportDeleter: SwiftlintReportDeleting = SwiftlintReportDeleter(),
        markdownAction: (String) -> Void = markdown,
        failAction: (String) -> Void = fail,
        failInlineAction: (String, String, Int) -> Void = fail,
        warnInlineAction: (String, String, Int) -> Void = warn,
        readFile: (String) -> String = danger.utils.readFile
    ) -> [SwiftLintViolation] {

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

        switch lintStyle {
        case .all(let directory):
            // Allow folks to lint all the potential files
            violations = lintAll(directory: directory,
                                 arguments: arguments,
                                 shellExecutor: shellExecutor,
                                 swiftlintPath: swiftlintPath,
                                 outputFilePath: outputFilePath,
                                 failAction: failAction,
                                 readFile: readFile)
        case .modifiedAndCreatedFiles(let directory):
            // Gathers modified+created files, invokes SwiftLint on each, and posts collected errors+warnings to Danger.
            var files = (danger.git.createdFiles + danger.git.modifiedFiles)
            if let directory = directory {
                files = files.filter { $0.hasPrefix(directory) }
            }

            violations = lintFiles(files,
                                   danger: danger,
                                   arguments: arguments,
                                   shellExecutor: shellExecutor,
                                   swiftlintPath: swiftlintPath,
                                   outputFilePath: outputFilePath,
                                   failAction: failAction,
                                   readFile: readFile)

        case .files(let files):
            violations = lintFiles(files,
                                   danger: danger,
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
    private static func lintFiles(_ files: [File],
                                  danger: DangerDSL,
                                  arguments: [String],
                                  shellExecutor: ShellExecuting,
                                  swiftlintPath: String,
                                  outputFilePath: String,
                                  failAction: (String) -> Void,
                                  readFile: (String) -> String) -> [SwiftLintViolation] {

        let files = files.filter { $0.fileType == .swift }
        
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
