import Foundation

private var dangerRunner: DangerRunner {
    DangerRunner.shared
}

/// Results available if you're doing @testable on
/// on Danger. This lets you check the results of
/// the feedback functions in plugins
private var testingResults = DangerResults()

/// Allows test vs app result tracking,
/// in the app all results are stored in a singleton,
/// controlled by DangerRunner, but in tests they
/// are accessible from the DangerResults object.
private var globalResults: DangerResults {
    get {
        if ProcessInfo.processInfo.processName.hasSuffix("xctest") {
            return testingResults
        } else {
            return DangerRunner.shared.results
        }
    }
    set {
        if ProcessInfo.processInfo.processName.hasSuffix("xctest") {
            testingResults = newValue
        } else {
            DangerRunner.shared.results = newValue
        }
    }
}

/// Resets the results array, useful for having in
/// setup functions for testing
func resetDangerResults() {
    globalResults.messages = []
    globalResults.fails = []
    globalResults.warnings = []
    globalResults.markdowns = []
    globalResults.meta = Meta()
}

public extension DangerDSL {
    /// Fails on the Danger report
    var fails: [Violation] {
        globalResults.fails
    }

    /// Warnings on the Danger report
    var warnings: [Violation] {
        globalResults.warnings
    }

    /// Messages on the Danger report
    var messages: [Violation] {
        globalResults.messages
    }

    /// Markdowns on the Danger report
    var markdowns: [Violation] {
        globalResults.markdowns
    }

    /// Meta information on the Danger report
    var meta: Meta {
        globalResults.meta
    }

    /// Adds a warning message to the Danger report
    ///
    /// - Parameter message: A markdown-ish
    func warn(_ message: String) {
        globalResults.warnings.append(Violation(message: message))
    }

    /// Adds an inline warning message to the Danger report
    func warn(message: String, file: String, line: Int) {
        globalResults.warnings.append(Violation(message: message, file: file, line: line))
    }

    /// Adds a warning message to the Danger report
    ///
    /// - Parameter message: A markdown-ish
    func fail(_ message: String) {
        globalResults.fails.append(Violation(message: message))
    }

    /// Adds an inline fail message to the Danger report
    func fail(message: String, file: String, line: Int) {
        globalResults.fails.append(Violation(message: message, file: file, line: line))
    }

    /// Adds a warning message to the Danger report
    ///
    /// - Parameter message: A markdown-ish
    func message(_ message: String) {
        globalResults.messages.append(Violation(message: message))
    }

    /// Adds an inline message to the Danger report
    func message(message: String, file: String, line: Int) {
        globalResults.messages.append(Violation(message: message, file: file, line: line))
    }

    /// Adds a warning message to the Danger report
    ///
    /// - Parameter message: A markdown-ish
    func markdown(_ message: String) {
        globalResults.markdowns.append(Violation(message: message))
    }

    /// Adds an inline message to the Danger report
    func markdown(message: String, file: String, line: Int) {
        globalResults.markdowns.append(Violation(message: message, file: file, line: line))
    }

    /// Adds an inline suggestion to the Danger report (sends a normal message if suggestions are not supported)
    func suggestion(code: String, file: String, line: Int) {
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

    /// Changes the meta information that will be passed back to Danger JS about this runtime
    func meta(_ meta: Meta) {
        globalResults.meta = meta
    }
}

/// Fails on the Danger report
public var fails: [Violation] {
    globalResults.fails
}

/// Warnings on the Danger report
public var warnings: [Violation] {
    globalResults.warnings
}

/// Messages on the Danger report
public var messages: [Violation] {
    globalResults.messages
}

/// Markdowns on the Danger report
public var markdowns: [Violation] {
    globalResults.markdowns
}

/// Meta information on the Danger report
var meta: Meta {
    globalResults.meta
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

/// Changes the meta information that will be passed back to Danger JS about this runtime
func meta(_ meta: Meta) {
    dangerRunner.dsl.meta(meta)
}
