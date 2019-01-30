import Foundation
import ShellOut

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
                            configFile: String? = nil, lintAllFiles: Bool = false,
                            swiftlintPath: String? = nil) -> [SwiftLintViolation] {
        return lint(danger: danger,
                    shellExecutor: shellExecutor,
                    swiftlintPath: swiftlintPath ?? SwiftLint.swiftlintDefaultPath(),
                    inline: inline,
                    directory: directory,
                    configFile: configFile,
                    lintAllFiles: lintAllFiles)
    }
}

/// This extension is for internal workings of the plugin. It is marked as internal for unit testing.
extension SwiftLint {
    // swiftlint:disable:next function_body_length
    static func lint(
        danger: DangerDSL,
        shellExecutor: ShellExecutor,
        swiftlintPath: String,
        inline: Bool = false,
        directory: String? = nil,
        configFile: String? = nil,
        lintAllFiles: Bool = false,
        currentPathProvider: CurrentPathProvider = DefaultCurrentPathProvider(),
        markdownAction: (String) -> Void = markdown,
        failAction: (String) -> Void = fail,
        failInlineAction: (String, String, Int) -> Void = fail,
        warnInlineAction: (String, String, Int) -> Void = warn
    ) -> [SwiftLintViolation] {
        var violations: [SwiftLintViolation]

        if lintAllFiles {
            // Allow folks to lint all the potential files
            var arguments = ["lint", "--quiet", "--reporter json"]
            if let directory = directory {
                arguments.append("--path \"\(directory)\"")
            }
            if let configFile = configFile {
                arguments.append("--config \"\(configFile)\"")
            }
            let outputJSON = shellExecutor.execute(swiftlintPath, arguments: arguments)
            violations = makeViolations(from: outputJSON, failAction: failAction)
        } else {
            // Gathers modified+created files, invokes SwiftLint on each, and posts collected errors+warnings to Danger.
            var files = (danger.git.createdFiles + danger.git.modifiedFiles).filter { $0.hasSuffix(".swift") }
            if let directory = directory {
                files = files.filter { $0.hasPrefix(directory) }
            }

            // swiftlint takes input files in the format:
            // `SCRIPT_INPUT_FILE_COUNT=2 SCRIPT_INPUT_FILE_0="file1" SCRIPT_INPUT_FILE_1="file2" swiftlint lint`
            var inputFiles = "SCRIPT_INPUT_FILE_COUNT=\(files.count)"
            for (index, file) in files.enumerated() {
                inputFiles.append(" SCRIPT_INPUT_FILE_\(index)=\"\(file)\"")
            }

            var arguments = ["lint", "--quiet", "--use-script-input-files", "--force-exclude", "--reporter json"]
            if let configFile = configFile {
                arguments.append("--config \"\(configFile)\"")
            }

            let command = [inputFiles, swiftlintPath].joined(separator: " ")
            let outputJSON = shellExecutor.execute(command, arguments: arguments)
            violations = makeViolations(from: outputJSON, failAction: failAction)
        }

        let currentPath = currentPathProvider.currentPath
        violations = violations.map { violation in
            let updatedPath = violation.file.deletingPrefix(currentPath).deletingPrefix("/")
            var violation = violation
            violation.update(file: updatedPath)
            return violation
        }

        if !violations.isEmpty {
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
        }

        return violations
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
