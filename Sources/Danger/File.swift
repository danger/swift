import Foundation

// MARK: - File

/// A simple typealias for strings representing files
public typealias File = String

extension File {
    public var fileType: FileType? {
        FileType(from: self)
    }

    public var name: String {
        String(self)
    }
}

// MARK: - FileType

public enum FileType: String, Equatable, CaseIterable {
    // swiftlint:disable:next identifier_name
    case h, json, m, markdown = "md", mm, pbxproj, plist, storyboard, swift, xcscheme, yaml, yml
}

// MARK: - FileType extensions

extension FileType {
    public var `extension`: String {
        rawValue
    }

    init?(from file: File) {
        let splittedPath = file.split(separator: ".")

        guard let fileTypeString = splittedPath.last,
            splittedPath.count > 1 else {
            return nil
        }

        self.init(rawValue: String(fileTypeString))
    }
}
