import Foundation

extension DateFormatter {
    // A default implementation of an iso8601 DateFormatter
    public static var defaultDateFormatter: DateFormatter {
        let dateFormatter = OptionalFractionalSecondsDateFormatter()
        return dateFormatter
    }
}

private final class OptionalFractionalSecondsDateFormatter: DateFormatter {
    static let withMilliseconds: DateFormatter = {
        let formatter = DateFormatter()
        setUpFormatter(formatter)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZZZZ"
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
