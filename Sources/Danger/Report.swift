import Foundation

private var dangerRunner: DangerRunner {
    return DangerRunner.shared
}

/// Results available if you're doing @testable on
/// on Danger. This lets you check the results of
/// the feedback functions in plugins
private var testingResults = DangerResults()

/// Allows test vs app result tracking,
/// in the app all results are stored in a singleton,
/// controlled by DangerRunner, but in tests they
/// are accessible from the DangerResults object.
var globalResults: DangerResults = {
    if ProcessInfo.processInfo.processName.hasSuffix("xctest") {
        return testingResults
    } else {
        return DangerRunner.shared.results
    }
}()

/// Resets the results array, useful for having in
/// setup functions for testing
func resetDangerResults() {
    globalResults.messages = []
    globalResults.fails = []
    globalResults.warnings = []
    globalResults.messages = []
}

extension DangerDSL {
    /// Fails on the Danger report
    public var fails: [Violation] {
        return globalResults.fails
    }

    /// Warnings on the Danger report
    public var warnings: [Violation] {
        return globalResults.warnings
    }

    /// Messages on the Danger report
    public var messages: [Violation] {
        return globalResults.messages
    }

    /// Markdowns on the Danger report
    public var markdowns: [Violation] {
        return globalResults.markdowns
    }

    /// Adds a warning message to the Danger report
    ///
    /// - Parameter message: A markdown-ish
    public func warn(_ message: String) {
        globalResults.warnings.append(Violation(message: message))
    }

    /// Adds an inline warning message to the Danger report
    public func warn(message: String, file: String, line: Int) {
        globalResults.warnings.append(Violation(message: message, file: file, line: line))
    }

    /// Adds a warning message to the Danger report
    ///
    /// - Parameter message: A markdown-ish
    public func fail(_ message: String) {
        globalResults.fails.append(Violation(message: message))
    }

    /// Adds an inline fail message to the Danger report
    public func fail(message: String, file: String, line: Int) {
        globalResults.fails.append(Violation(message: message, file: file, line: line))
    }

    /// Adds a warning message to the Danger report
    ///
    /// - Parameter message: A markdown-ish
    public func message(_ message: String) {
        globalResults.messages.append(Violation(message: message))
    }

    /// Adds an inline message to the Danger report
    public func message(message: String, file: String, line: Int) {
        globalResults.messages.append(Violation(message: message, file: file, line: line))
    }

    /// Adds a warning message to the Danger report
    ///
    /// - Parameter message: A markdown-ish
    public func markdown(_ message: String) {
        globalResults.markdowns.append(Violation(message: message))
    }

    /// Adds an inline message to the Danger report
    public func markdown(message: String, file: String, line: Int) {
        globalResults.markdowns.append(Violation(message: message, file: file, line: line))
    }

    /// Adds an inline suggestion to the Danger report (sends a normal message if suggestions are not supported)
    public func suggestion(code: String, file: String, line: Int) {
        let message: String

        if dangerRunner.dsl.supportsSuggestions {
            message = """
            ```suggestion
            \(code)
            ```
            """
        } else {
            message = code
        }

        globalResults.markdowns.append(Violation(message: message, file: file, line: line))
    }
}

/// Fails on the Danger report
public var fails: [Violation] {
    return globalResults.fails
}

/// Warnings on the Danger report
public var warnings: [Violation] {
    return globalResults.warnings
}

/// Messages on the Danger report
public var messages: [Violation] {
    return globalResults.messages
}

/// Markdowns on the Danger report
public var markdowns: [Violation] {
    return globalResults.markdowns
}

/// Adds a warning message to the Danger report
///
/// - Parameter message: A markdown-ish
public func warn(_ message: String) {
    dangerRunner.dsl.warn(message)
}

/// Adds an inline warning message to the Danger report
public func warn(message: String, file: String, line: Int) {
    dangerRunner.dsl.warn(message: message, file: file, line: line)
}

/// Adds a warning message to the Danger report
///
/// - Parameter message: A markdown-ish
public func fail(_ message: String) {
    dangerRunner.dsl.fail(message)
}

/// Adds an inline fail message to the Danger report
public func fail(message: String, file: String, line: Int) {
    dangerRunner.dsl.fail(message: message, file: file, line: line)
}

/// Adds a warning message to the Danger report
///
/// - Parameter message: A markdown-ish
public func message(_ message: String) {
    dangerRunner.dsl.message(message)
}

/// Adds an inline message to the Danger report
public func message(message: String, file: String, line: Int) {
    dangerRunner.dsl.message(message: message, file: file, line: line)
}

/// Adds a warning message to the Danger report
///
/// - Parameter message: A markdown-ish
public func markdown(_ message: String) {
    dangerRunner.dsl.markdown(message)
}

/// Adds an inline message to the Danger report
public func markdown(message: String, file: String, line: Int) {
    dangerRunner.dsl.markdown(message: message, file: file, line: line)
}

/// Adds an inline suggestion to the Danger report (sends a normal message if suggestions are not supported)
public func suggestion(code: String, file: String, line: Int) {
    dangerRunner.dsl.suggestion(code: code, file: file, line: line)
}
