import Foundation

// MARK: - Violation

/// The result of a warn, message, or fail.
public struct Violation: Encodable {
    let message: String
    let file: String?
    let line: Int?

    init(message: String, file: String? = nil, line: Int? = nil) {
        self.message = message
        self.file = file
        self.line = line
    }
}

/// Meta information for showing in the text info
public struct Meta: Encodable {
    let runtimeName: String
    let runtimeHref: String

    public init(
        runtimeName: String = "Danger Swift",
        runtimeHref: String = "https://danger.systems/swift"
    ) {
        self.runtimeName = runtimeName
        self.runtimeHref = runtimeHref
    }
}

// MARK: - Results

/// The representation of what running a Dangerfile generates.
struct DangerResults: Encodable {
    /// Failed messages.
    var fails = [Violation]()

    /// Messages for info.
    var warnings = [Violation]()

    /// A set of messages to show inline.
    var messages = [Violation]()

    /// Markdown messages to attach at the bottom of the comment.
    var markdowns = [Violation]()

    /// Information to pass back to Danger JS about the runtime
    var meta = Meta()
}
