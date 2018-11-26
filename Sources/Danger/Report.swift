//
//  Report.swift
//  Danger
//
//  Created by Franco Meloni on 19/11/2018.
//

private var dangerRunner: DangerRunner {
    return DangerRunner.shared
}

extension DangerDSL {
    /// Fails on the Danger report
    public var fails: [Violation] {
        return dangerRunner.results.fails
    }

    /// Warnings on the Danger report
    public var warnings: [Violation] {
        return dangerRunner.results.warnings
    }

    /// Messages on the Danger report
    public var messages: [Violation] {
        return dangerRunner.results.messages
    }

    /// Markdowns on the Danger report
    public var markdowns: [Violation] {
        return dangerRunner.results.markdowns
    }

    /// Adds a warning message to the Danger report
    ///
    /// - Parameter message: A markdown-ish
    public func warn(_ message: String) {
        dangerRunner.results.warnings.append(Violation(message: message))
    }

    /// Adds an inline warning message to the Danger report
    public func warn(message: String, file: String, line: Int) {
        dangerRunner.results.warnings.append(Violation(message: message, file: file, line: line))
    }

    /// Adds a warning message to the Danger report
    ///
    /// - Parameter message: A markdown-ish
    public func fail(_ message: String) {
        dangerRunner.results.fails.append(Violation(message: message))
    }

    /// Adds an inline fail message to the Danger report
    public func fail(message: String, file: String, line: Int) {
        dangerRunner.results.fails.append(Violation(message: message, file: file, line: line))
    }

    /// Adds a warning message to the Danger report
    ///
    /// - Parameter message: A markdown-ish
    public func message(_ message: String) {
        dangerRunner.results.messages.append(Violation(message: message))
    }

    /// Adds an inline message to the Danger report
    public func message(message: String, file: String, line: Int) {
        dangerRunner.results.messages.append(Violation(message: message, file: file, line: line))
    }

    /// Adds a warning message to the Danger report
    ///
    /// - Parameter message: A markdown-ish
    public func markdown(_ message: String) {
        dangerRunner.results.markdowns.append(Violation(message: message))
    }

    /// Adds an inline message to the Danger report
    public func markdown(message: String, file: String, line: Int) {
        dangerRunner.results.markdowns.append(Violation(message: message, file: file, line: line))
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

        dangerRunner.results.markdowns.append(Violation(message: message, file: file, line: line))
    }
}

/// Fails on the Danger report
public var fails: [Violation] {
    return dangerRunner.dsl.fails
}

/// Warnings on the Danger report
public var warnings: [Violation] {
    return dangerRunner.dsl.warnings
}

/// Messages on the Danger report
public var messages: [Violation] {
    return dangerRunner.dsl.messages
}

/// Markdowns on the Danger report
public var markdowns: [Violation] {
    return dangerRunner.dsl.markdowns
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
