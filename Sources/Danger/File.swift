import Foundation

// MARK: - File

/// A simple typealias for strings representing files
public typealias File = String

public extension File {
    var fileType: FileType? {
        FileType(from: self)
    }

    var name: String {
        String(self)
    }
}

// MARK: - FileType

public enum FileType: String, Equatable, CaseIterable {
    // swiftlint:disable:next identifier_name
    case h, json, m, markdown = "md", mm, pbxproj, plist, storyboard, swift, xcscheme, yaml, yml, xctestplan
}

// MARK: - FileType extensions

extension FileType {
    public var `extension`: String {
        rawValue
    }

    init?(from file: File) {
        let splittedPath = file.split(separator: ".")

        guard let fileTypeString = splittedPath.last,
              splittedPath.count > 1
        else {
            return nil
        }

        self.init(rawValue: String(fileTypeString))
    }
}
