import Foundation

public final class ImportsFinder {
    public init() {}

    public func findImports(inString string: String) -> [String] {
        let regex = NSRegularExpression.filesImportRegex
        let matches = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count))
        let files = matches.map { regex.replacementString(for: $0, in: string, offset: 0, template: "$1") }

        return files
    }

    public func resolveImportPath(_ path: String,
                                  relativeTo dangerfilePath: String) -> String
    {
        dangerfilePath
            .removingLastPathComponent()
            .appendingPath(path)
    }
}
