import Foundation

protocol SwiftlintReportDeleting {
    func deleteReport(atPath path: String) throws
}

struct SwiftlintReportDeleter: SwiftlintReportDeleting {
    let fileManager: FileManager

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    func deleteReport(atPath path: String) throws {
        try fileManager.removeItem(atPath: path)
    }
}
