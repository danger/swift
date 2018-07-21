import Foundation

// MARK: - File

/// A simple typealias for strings representing files
public typealias File = String

public extension File {
    var fileType: FileType? {
        return FileType(from: self)
    }
}

// MARK: - FileType

public enum FileType: String { // Try verticle version
    case h
    case json
    case m
    case markdown = "md"
    case pbxproj
    case plist
    case storyboard
    case swift
}

extension FileType {
    
    @available(swift, deprecated: 4.2, message: "Replace with CaseIterable conformance")
    static internal var allCases: [FileType] {
        return [.h, .json, .m, .markdown, .pbxproj, .plist, .storyboard, .swift]
    }
    
    public var `extension`: String {
        return rawValue
    }
    
    public init?(from fileName: String) {
        let allCasesDelimited = FileType.allCases.map { $0.extension }.joined(separator: "|")
        
        // TODO: move ugly regex stuff to tested extension where it belongs, write tests
        guard
            let regex = try? NSRegularExpression(pattern: "\\.(\(allCasesDelimited))$", options: []),
            let match = regex.firstMatch(in: fileName, options: [], range: NSRange(location: 0, length: fileName.count)),
            let range = Range(match.range, in: fileName)
            else {
                return nil
        }
        
        let rawValue = String(fileName[range])
        self.init(rawValue: rawValue)
    }
    
}
