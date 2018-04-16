import Foundation

// MARK: - Violation

/// The result of a warn, message, or fail.
struct Violation: Codable {

    let message: String
}

// MARK: - Results

/// The representation of what running a Dangerfile generates.
struct DangerResults: Codable {

    /// Failed messages.
    var fails = [Violation]()

    /// Messages for info.
    var warnings = [Violation]()

    /// A set of messages to show inline.
    var messages = [Violation]()

    /// Markdown messages to attach at the bottom of the comment.
    var markdowns = [String]()

}
