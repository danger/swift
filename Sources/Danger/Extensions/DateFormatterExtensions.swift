import Foundation

public extension DateFormatter {
    // A default implementation of an iso8601 DateFormatter
    static var defaultDateFormatter: DateFormatter {
        let dateFormatter = OptionalFractionalSecondsDateFormatter()
        return dateFormatter
    }

    static var onlyDateDateFormatter: DateFormatter {
        let dateFormatter = OptionalFractionalSecondsDateFormatter.onlyDate
        return dateFormatter
    }

    /// Handles multiple date format inside models.
    static func dateFormatterHandler(_ decoder: Decoder) throws -> Date {
        let dateString = try decoder.singleValueContainer().decode(String.self)
        if let date = defaultDateFormatter.date(from: dateString) {
            return date
        } else if let date = onlyDateDateFormatter.date(from: dateString) {
            return date
        } else {
            let path = decoder.codingPath.map(\.stringValue).joined(separator: ".")
            throw OptionalFractionalSecondsDateFormatter
                .DateError
                .invalidFormat(path: path, dateString: dateString)
        }
    }
}

private final class OptionalFractionalSecondsDateFormatter: DateFormatter, @unchecked Sendable {
    static let withMilliseconds: DateFormatter = {
        let formatter = DateFormatter()
        setUpFormatter(formatter)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZZZZ"
        return formatter
    }()

    static let onlyDate: DateFormatter = {
        let formatter = DateFormatter()
        setUpFormatter(formatter)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    static func setUpFormatter(_ formatter: DateFormatter) {
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
    }

    func setup() {
        OptionalFractionalSecondsDateFormatter.setUpFormatter(self)
        dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
    }

    override init() {
        super.init()
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override func date(from string: String) -> Date? {
        if let result = super.date(from: string) {
            return result
        }
        return OptionalFractionalSecondsDateFormatter.withMilliseconds.date(from: string)
    }
}

extension OptionalFractionalSecondsDateFormatter {
    enum DateError: LocalizedError {
        case invalidFormat(path: String, dateString: String)

        // MARK: LocalizedError

        var errorDescription: String? {
            switch self {
            case let .invalidFormat(path, dateString):
                return "Format Invalid with path \"\(path)\", date string: \"\(dateString)\""
            }
        }
    }
}
