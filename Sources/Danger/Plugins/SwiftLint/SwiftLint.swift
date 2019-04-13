import DangerExecutor
import Foundation

/// The SwiftLint plugin has been embedded inside Danger, making
/// it usable out of the box.
public struct SwiftLint {
    internal static let danger = Danger()
    internal static let shellExecutor = ShellExecutor()

    /// This is the main entry point for linting Swift in PRs.
    ///
    /// When the swiftlintPath is not specified,
    /// it uses by default swift run swiftlint if the Package.swift contains swiftlint as dependency,
    /// otherwise calls directly the swiftlint command

    @discardableResult
    public static func lint(inline: Bool = false, directory: String? = nil,
                            configFile: String? = nil, strict: Bool = false, lintAllFiles: Bool = false,
                            swiftlintPath: String? = nil) -> [SwiftLintViolation] {
        return lint(danger: danger,
                    shellExecutor: shellExecutor,
                    swiftlintPath: swiftlintPath ?? SwiftLint.swiftlintDefaultPath(),
                    inline: inline,
                    directory: directory,
                    configFile: configFile,
                    strict: strict,
                    lintAllFiles: lintAllFiles)
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
        lintAllFiles: Bool = false,
        currentPathProvider: CurrentPathProvider = DefaultCurrentPathProvider(),
        markdownAction: (String) -> Void = markdown,
        failAction: (String) -> Void = fail,
        failInlineAction: (String, String, Int) -> Void = fail,
        warnInlineAction: (String, String, Int) -> Void = warn
    ) -> [SwiftLintViolation] {
        var arguments = ["lint", "--quiet", "--reporter json"]

        if let configFile = configFile {
            arguments.append("--config \"\(configFile)\"")
        }

        var violations: [SwiftLintViolation]
        if lintAllFiles {
            // Allow folks to lint all the potential files
            violations = lintAll(directory: directory,
                                 arguments: arguments,
                                 shellExecutor: shellExecutor,
                                 swiftlintPath: swiftlintPath,
                                 failAction: failAction)
        } else {
            violations = lintModifiedAndCreated(danger: danger,
                                                directory: directory,
                                                arguments: arguments,
                                                shellExecutor: shellExecutor,
                                                swiftlintPath: swiftlintPath,
                                                failAction: failAction)
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

    private static func lintAll(directory: String?,
                                arguments: [String],
                                shellExecutor: ShellExecuting,
                                swiftlintPath: String,
                                failAction: (String) -> Void) -> [SwiftLintViolation] {
        var arguments = arguments

        if let directory = directory {
            arguments.append("--path \"\(directory)\"")
        }

        let outputJSON = shellExecutor.execute(swiftlintPath, arguments: arguments)
        return makeViolations(from: outputJSON, failAction: failAction)
    }

    // swiftlint:disable function_parameter_count
    private static func lintModifiedAndCreated(danger: DangerDSL,
                                               directory: String?,
                                               arguments: [String],
                                               shellExecutor: ShellExecuting,
                                               swiftlintPath: String,
                                               failAction: (String) -> Void) -> [SwiftLintViolation] {
        // Gathers modified+created files, invokes SwiftLint on each, and posts collected errors+warnings to Danger.
        var files = (danger.git.createdFiles + danger.git.modifiedFiles).filter { $0.fileType == .swift }
        if let directory = directory {
            files = files.filter { $0.hasPrefix(directory) }
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

        let outputJSON = shellExecutor.execute(swiftlintPath,
                                               arguments: arguments,
                                               environmentVariables: inputFiles)
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
}

private extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }
        return String(dropFirst(prefix.count))
    }
}
