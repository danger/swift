import Foundation

extension DateFormatter {
    // A default implementation of an iso8601 DateFormatter
    public static var defaultDateFormatter: DateFormatter {
        let dateFormatter = OptionalFractionalSecondsDateFormatter()
        return dateFormatter
    }

    public static var onlyDateDateFormatter: DateFormatter {
        let dateFormatter = OptionalFractionalSecondsDateFormatter.onlyDate
        return dateFormatter
    }

    /// Handles multiple date format inside models.
    public static func dateFormatterHandler(_ decoder: Decoder) throws -> Date {
        let dateString = try decoder.singleValueContainer().decode(String.self)
        if let date = defaultDateFormatter.date(from: dateString) {
            return date
        } else if let date = onlyDateDateFormatter.date(from: dateString) {
            return date
        } else {
            fatalError("Unexpected date coding key: \(decoder.codingPath.last?.stringValue ?? "Not Valid Key Name")")
        }
    }
}

private final class OptionalFractionalSecondsDateFormatter: DateFormatter {
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
