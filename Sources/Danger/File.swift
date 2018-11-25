import Foundation

// MARK: - File

/// A simple typealias for strings representing files
public typealias File = String

extension File {
    public var fileType: FileType? {
        return FileType(from: self)
    }

    public var name: String {
        return String(self)
    }
}

// MARK: - FileType

public enum FileType: String, Equatable {
    case h, json, m, markdown = "md", mm, pbxproj, plist, storyboard, swift, xcscheme, yaml, yml
}

#if swift(>=4.2) // Use compiler-generated allCases when available
    extension FileType: CaseIterable {}
#else
    extension FileType {
        static var allCases: [FileType] {
            return [.h, .json, .m, .markdown, .mm, .pbxproj, .plist, .storyboard, .swift, .xcscheme, .yaml, .yml]
        }
    }
#endif

// MARK: - FileType extensions

extension FileType {
    public var `extension`: String {
        return rawValue
    }

    init?(from file: File) {
        let allCasesDelimited = FileType.allCases.map { $0.extension }.joined(separator: "|")

        guard
            let pattern = try? NSRegularExpression(pattern: "\\.(\(allCasesDelimited))$"),
            let match = pattern.firstMatchingString(in: file.name)
        else {
            return nil
        }

        let rawValue = match.replacingOccurrences(of: ".", with: "")
        self.init(rawValue: rawValue)
    }
}
