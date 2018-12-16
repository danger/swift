import Foundation

extension NSRegularExpression {
    private static let fileImportPattern = "\\/\\/[\\ ]?fileImport:\\ (.*)"

    static let filesImportRegex = try! NSRegularExpression(pattern: fileImportPattern, options: .allowCommentsAndWhitespace)
}
