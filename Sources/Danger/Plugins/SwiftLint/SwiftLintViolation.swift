public struct SwiftLintViolation: Decodable {
    enum Severity: String, Decodable {
        case warning = "Warning"
        case error = "Error"
    }

    var ruleID: String
    var reason: String
    var line: Int
    var severity: Severity
    var type: String
    var file: String

    var messageText: String {
        return reason + " (`\(ruleID)`)"
    }

    enum CodingKeys: String, CodingKey {
        case ruleID = "rule_id"
        case reason, line, file, severity, type
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ruleID = try values.decode(String.self, forKey: .ruleID)
        reason = try values.decode(String.self, forKey: .reason)
        line = try values.decode(Int.self, forKey: .line)
        file = try values.decode(String.self, forKey: .file)
        severity = try values.decode(Severity.self, forKey: .severity)
        type = try values.decode(String.self, forKey: .type)
    }

    public init?(dictionary: [String: Any]) {
        guard let ruleID = dictionary[CodingKeys.ruleID.rawValue] as? String,
            let reason = dictionary[CodingKeys.reason.rawValue] as? String,
            let line = dictionary[CodingKeys.line.rawValue] as? Int,
            let file = dictionary[CodingKeys.file.rawValue] as? String,
            let severityString = dictionary[CodingKeys.severity.rawValue] as? String,
            let severity = Severity(rawValue: severityString),
            let type = dictionary[CodingKeys.type.rawValue] as? String else {
            return nil
        }

        self.ruleID = ruleID
        self.reason = reason
        self.line = line
        self.severity = severity
        self.type = type
        self.file = file
    }

    public func toMarkdown() -> String {
        let formattedFile = file.split(separator: "/").last! + ":\(line)"
        return "\(severity.rawValue) | \(formattedFile) | \(messageText) |"
    }
}

/*
 "rule_id" : "opening_brace",
 "reason" : "Opening braces should be preceded by a single space and on the same line as the declaration.",
 "character" : 39,
 "file" : "\/Users\/ash\/bin\/Harvey\/Sources\/Harvey\/Harvey.swift",
 "severity" : "Warning",
 "type" : "Opening Brace Spacing",
 "line" : 8
 */
