import DangerShellExecutor
import Foundation
import Version

public struct PackageManager {
    enum Errors: Error {
        case failedToUpdatePackages(String)
        case unrecognizedTagFormat(String)
    }

    private let folder: String
    private let generatedFolder: String
    private let temporaryFolder: String
    private let packageListMaker: PackageListMaker
    private let packageGenerator: PackageGenerator
    private let fileCreator: FileCreating
    private let fileReader: FileReading
    private let packageDataProvider: PackageDataProviding
    private var masterPackageName: String { return "PACKAGES" }

    // MARK: - Init

    public init(folder: String) throws {
        try self.init(folder: folder,
                      fileReader: FileReader(),
                      fileCreator: FileCreator(),
                      packageDataProvider: PackageDataProvider())
    }

    init(folder: String,
         fileReader: FileReading,
         fileCreator: FileCreating,
         packageDataProvider: PackageDataProviding) throws {
        self.folder = folder
        self.fileReader = fileReader
        self.fileCreator = fileCreator
        self.packageDataProvider = packageDataProvider
        generatedFolder = try folder.createSubfolderIfNeeded(withName: "Generated")
        temporaryFolder = try folder.createSubfolderIfNeeded(withName: "Temp")
        packageGenerator = PackageGenerator(folder: folder, generatedFolder: generatedFolder)
        packageListMaker = PackageListMaker(folder: folder, fileManager: .default, dataReader: FileReader())
    }

    func addPackagesIfNeeded(from packageURLs: [URL]) throws {
        let existingPackageURLs = Set(packageListMaker.makePackageList().map { package in
            package.url.absoluteString.lowercased()
        })

        for url in packageURLs {
            guard !existingPackageURLs.contains(url.absoluteString.lowercased()) else {
                continue
            }

            try addPackage(at: url)
        }
    }

    @discardableResult func addPackage(at url: URL) throws -> Package {
        let name = try packageDataProvider.nameOfPackage(at: url, temporaryFolder: temporaryFolder)

        let latestVersion = try packageDataProvider.latestMajorVersionForPackage(at: url)
        let package = Package(name: name, url: absoluteRepositoryURL(from: url), majorVersion: latestVersion)
        try save(package: package)

        try updatePackages()
        try addMissingPackageFiles()

        return package
    }

    private func save(package: Package) throws {
        try fileCreator.createFile(atPath: folder.appendingPath(package.name), contents: package.encoded())
    }

    private func addMissingPackageFiles() throws {
        for pinnedPackage in try packageDataProvider.resolvePinnedPackages(generatedFolder: generatedFolder) {
            guard !folder.containsItem(named: pinnedPackage.name) else {
                continue
            }

            let package = Package(
                name: pinnedPackage.name,
                url: pinnedPackage.url,
                majorVersion: pinnedPackage.state.version.major
            )

            try save(package: package)
        }
    }

    private func absoluteRepositoryURL(from url: URL) -> URL {
        guard !url.isForRemoteRepository else {
            return url
        }

        let path = url.absoluteString
        return URL(string: path)!
    }

    func symlinkPackages(to folder: String) throws {
        let checkoutsFolder = generatedFolder.appendingPath(".build/checkouts")
        let repositoriesFolder = generatedFolder.appendingPath(".build/repositories")
        let resolvedPackageFile = generatedFolder.appendingPath("Package.resolved")

        guard FileManager.default.fileExists(atPath: checkoutsFolder),
            FileManager.default.fileExists(atPath: repositoriesFolder) else {
            try updatePackages()
            return try symlinkPackages(to: folder)
        }

        let buildFolder = try folder.createSubfolderIfNeeded(withName: ".build")

        if !buildFolder.containsItem(named: "checkouts") {
            try buildFolder.createSymlink(to: checkoutsFolder, at: "checkouts")
        }

        if !buildFolder.containsItem(named: "repositories") {
            try buildFolder.createSymlink(to: repositoriesFolder, at: "repositories")
        }

        if !folder.containsItem(named: "Package.resolved") {
            try folder.createSymlink(to: resolvedPackageFile, at: "Package.resolved")
        }
    }

    func makePackageDescription(for script: Script) throws -> Data {
        guard let masterDescription = try? String(contentsOfFile: generatedFolder.appendingPath("Package.swift")) else {
            try updatePackages()
            return try makePackageDescription(for: script)
        }

        let toolsVersion = try resolveSwiftToolsVersion(executor: ShellExecutor(), onFolder: generatedFolder)
        let expectedHeader = packageGenerator.makePackageDescriptionHeader(forSwiftToolsVersion: toolsVersion)

        guard masterDescription.hasPrefix(expectedHeader) else {
            try packageGenerator.generateMasterPackageDescription(forSwiftToolsVersion: toolsVersion)
            return try makePackageDescription(for: script)
        }

        return masterDescription.replacingOccurrences(of: masterPackageName, with: script.name).data(using: .utf8) ?? Data()
    }

    private func updatePackages() throws {
        //           printer.reportProgress("Updating packages...")

        do {
            let executor = ShellExecutor()

            let toolsVersion = try resolveSwiftToolsVersion(executor: executor, onFolder: generatedFolder)
            try packageGenerator.generateMasterPackageDescription(forSwiftToolsVersion: toolsVersion)
            try executeSwiftCommand("package update", onFolder: generatedFolder, arguments: [], executor: executor)
            try generatedFolder.createSubfolderIfNeeded(withName: "Packages")
        } catch {
            throw Errors.failedToUpdatePackages(folder)
        }
    }

    private func resolveSwiftToolsVersion(executor: ShellExecutor, onFolder _: String) throws -> Version {
        var versionString: String? = try executeSwiftCommand("package", onFolder: folder, arguments: ["--version"], executor: executor)
        versionString = versionString?.components(separatedBy: " (swiftpm").first
        versionString = versionString?.deletingPrefix("Apple Swift Package Manager - Swift ")

        let versionComponents = versionString?.components(separatedBy: ".") ?? []

        if versionComponents.count > 2 {
            versionString = "\(versionComponents[0]).\(versionComponents[1]).\(versionComponents[2])"
        }

        return Version(versionString ?? "") ?? .null
    }
}

extension String {
    private enum Errors: Error {
        case folderCreationFailed(String)
    }

    private var fileManager: FileManager {
        return .default
    }

    @discardableResult
    func createSubfolderIfNeeded(withName folderName: String) throws -> String {
        let folderPath = appendingPath(folderName)
        if fileManager.fileExists(atPath: folderPath) {
            return folderPath
        } else {
            return try createSubfolder(folderPath: folderPath)
        }
    }

    func createSubfolder(withName name: String) throws -> String {
        return try createSubfolder(folderPath: appendingPath(name))
    }

    func containsItem(named item: String) -> Bool {
        return (try? fileManager.contentsOfDirectory(atPath: self).contains(item)) ?? false
    }

    func createSymlink(to originalPath: String, at linkPath: String) throws {
        let executor = ShellExecutor()
        try executor.spawn("cd \(self) && ln -s \"\(originalPath)\" \"\(linkPath)\"", arguments: [])
    }

    private func createSubfolder(folderPath: String) throws -> String {
        do {
            try fileManager.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: nil)
            return folderPath
        } catch {
            throw Errors.folderCreationFailed(folderPath)
        }
    }

    func appendingPath(_ path: String) -> String {
        if hasSuffix("/") {
            return self + path
        } else {
            return self + "/" + path
        }
    }

    fileprivate func deletingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }
        return String(dropFirst(prefix.count))
    }
}
