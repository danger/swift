import Foundation

// MARK: - File

/// A simple typealias for strings representing files
public typealias File = String

extension File {

    public var fileType: FileType? {
        return FileType(from: self)
    }

}

// MARK: - FileType

public enum FileType: String {
    case h, json, m, markdown = "md", pbxproj, plist, storyboard, swift

    @available(swift, deprecated: 4.2, message: "Replace with CaseIterable conformance")
    static internal var allCases: [FileType] {
        return [.h, .json, .m, .markdown, .pbxproj, .plist, .storyboard, .swift]
    }
}

// MARK: - Public extensions

extension FileType {

    public var `extension`: String {
        return rawValue
    }

    public init?(from fileName: String) {
        let allCasesDelimited = FileType.allCases.map { $0.extension }.joined(separator: "|")

        guard
            let pattern = try? NSRegularExpression(pattern: "\\.(\(allCasesDelimited))$"),
            let rawValue = pattern.firstMatchingString(in: fileName)
        else {
            return nil
        }

        self.init(rawValue: rawValue)
    }

}
