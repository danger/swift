import DangerShellExecutor
import Foundation
import Logger

protocol PackageDataProviding {
    func nameOfPackage(at url: URL, temporaryFolder: String) throws -> String
}

struct PackageDataProvider: PackageDataProviding {
    let fileReader: FileReading
    let logger: Logger
    let executor: ShellExecuting

    init(logger: Logger = Logger(),
         fileReader: FileReading = FileReader(),
         executor: ShellExecuting = ShellExecutor()) {
        self.fileReader = fileReader
        self.logger = logger
        self.executor = executor
    }

    enum Errors: Error {
        case failedToResolveName(URL)
        case failedToReadPackageFile(String)
    }

    func nameOfPackage(at url: URL, temporaryFolder: String) throws -> String {
        do {
            logger.logInfo("AAAA \(url.absoluteURL)")
            guard !url.isForRemoteRepository else {
                return try nameOfRemotePackage(at: url, temporaryFolder: temporaryFolder)
            }

            let folder = url.absoluteString
            return try nameOfPackage(in: folder)
        } catch {
            throw Errors.failedToResolveName(url)
        }
    }

    private func nameOfRemotePackage(at url: URL, temporaryFolder: String) throws -> String {
        removeCloneFolder(temporaryFolder: temporaryFolder)

        logger.logInfo("Cloning \(url.absoluteString)...")

        let clone = temporaryFolder.appendingPath("Clone")
        try executor.spawn("git clone", arguments: ["\(url.absoluteString)", "--single-branch", "--depth 1", "\(clone)", "-q"])
        let name = try nameOfPackage(in: clone)
        removeCloneFolder(temporaryFolder: temporaryFolder)

        return name
    }

    private func nameOfPackage(in folder: String) throws -> String {
        let packageFile = folder.appendingPath("Package.swift")

        for line in try fileReader.readText(atPath: packageFile).components(separatedBy: .newlines) {
            guard let nameTokenRange = line.range(of: "name:") else {
                continue
            }

            var line = String(line[nameTokenRange.upperBound...])

            if let range = line.range(of: ",") {
                line = String(line[..<range.lowerBound])
            } else if let range = line.range(of: ")") {
                line = String(line[..<range.lowerBound])
            }

            line = line.trimmingCharacters(in: .whitespacesAndNewlines)
            return line.replacingOccurrences(of: "\"", with: "")
        }

        throw Errors.failedToReadPackageFile(packageFile)
    }

    private func removeCloneFolder(temporaryFolder: String) {
        try? FileManager.default.removeItem(atPath: temporaryFolder.appendingPath("Clone"))
    }
}
