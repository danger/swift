import Logger
import DangerShellExecutor
import Foundation

struct PackageDataProvider {
    let temporaryFolder: String
    let fileReader: FileReading
    let logger: Logger
    let executor: ShellExecuting
    
    init(temporaryFolder: String,
         fileReader: FileReading,
         logger: Logger,
         executor: ShellExecuting = ShellExecutor()) {
        self.temporaryFolder = temporaryFolder
        self.fileReader = fileReader
        self.logger = logger
        self.executor = executor
    }
    
    enum Errors: Error {
        case failedToResolveName(URL)
        case failedToReadPackageFile(String)
    }
    
    func nameOfPackage(at url: URL) throws -> String {
        do {
            guard !url.isForRemoteRepository else {
                return try nameOfRemotePackage(at: url)
            }
            
            let folder = url.absoluteString
            return try nameOfPackage(in: folder)
        } catch {
            throw Errors.failedToResolveName(url)
        }
    }
    
    private func nameOfRemotePackage(at url: URL) throws -> String {
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
