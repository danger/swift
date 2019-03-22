import Foundation
import Logger

public final class DangerFileGenerator {
    public init() {}

    public func generateDangerFile(fromContent content: String, fileName: String, logger: Logger) throws {
        var dangerContent = content
        let importsRegex = NSRegularExpression.filesImportRegex

        importsRegex.enumerateMatches(in: content, options: [], range: NSRange(location: 0, length: content.count), using: { result, _, _ in
            // Adjust the result to have the correct range also after dangerContent is modified
            guard let result = result?.adjustingRanges(offset:
                dangerContent.utf16.count - content.utf16.count) else { return }
            let url = importsRegex.replacementString(for: result, in: dangerContent, offset: 0, template: "$1")

            guard let fileContent = try? String(contentsOfFile: url),
                let replacementRange = Range<String.Index>(result.range, in: dangerContent) else {
                logger.logWarning("File not found at \(url)")
                return
            }

            dangerContent.replaceSubrange(replacementRange, with: fileContent)
        })

        try dangerContent.write(toFile: fileName, atomically: false, encoding: .utf8)
    }
}
