import DangerShellExecutor
import Foundation
import Version

public struct PackageManager {
    enum Errors: Error {
        case failedToResolveName(URL)
        case failedToResolveLatestVersion(URL)
        case failedToReadPackageFile(String)
        case failedToUpdatePackages(String)
        case unrecognizedTagFormat(String)
    }

    private let folder: String
    private let generatedFolder: String
    private let temporaryFolder: String
    private var masterPackageName: String { return "PACKAGES" }

    // MARK: - Init

    public init(folder: String) throws {
        self.folder = folder
        generatedFolder = try folder.createSubfolderIfNeeded(withName: "Generated")
        temporaryFolder = try folder.createSubfolderIfNeeded(withName: "Temp")
    }

    func addPackagesIfNeeded(from packageURLs: [URL]) throws {
        let existingPackageURLs = Set(makePackageList().map { package in
            package.url.absoluteString.lowercased()
        })

        for url in packageURLs {
            guard !existingPackageURLs.contains(url.absoluteString.lowercased()) else {
                continue
            }

            try addPackage(at: url, throwIfAlreadyAdded: false)
        }
    }

    private func makePackageList() -> [Package] {
        return folder.files.compactMap {
            try? (String(contentsOfFile: $0).data(using: .utf8) ?? Data()).decoded()
        }
    }

    @discardableResult func addPackage(at url: URL, throwIfAlreadyAdded _: Bool = true) throws -> Package {
        let name = try nameOfPackage(at: url)

//        if throwIfAlreadyAdded {
//            guard (try? folder.file(named: name)) == nil else {
//                throw Errors.packageAlreadyAdded(name)
//            }
//        }

        let latestVersion = try latestMajorVersionForPackage(at: url)
        let package = Package(name: name, url: absoluteRepositoryURL(from: url), majorVersion: latestVersion)
        try save(package: package)

        try updatePackages()
        addMissingPackageFiles()

        return package
    }

    private func save(package: Package) throws {
        try FileManager.default.createFile(atPath: folder + package.name, contents: package.encoded(), attributes: [:])
    }

    private func addMissingPackageFiles() {
        do {
            for pinnedPackage in try resolvePinnedPackages() {
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
        } catch {}
    }

    private func resolvePinnedPackages() throws -> [Package.Pinned] {
        struct ResolvedPackagesState: Decodable {
            struct Object: Decodable {
                let pins: [Package.Pinned]
            }

            let object: Object
        }

        let data = try String(contentsOfFile: generatedFolder + "Package.resolved").data(using: .utf8) ?? Data()
        let state = try data.decoded() as ResolvedPackagesState
        return state.object.pins
    }

    private func absoluteRepositoryURL(from url: URL) -> URL {
        guard !url.isForRemoteRepository else {
            return url
        }

        let path = url.absoluteString
        return URL(string: path)!
    }

    private func nameOfPackage(at url: URL) throws -> String {
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

//        printer.reportProgress("Cloning \(url.absoluteString)...")

        let executor = ShellExecutor()
        try executor.spawn("git clone", arguments: ["\(url.absoluteString)", "--single-branch", "--depth 1", "\(temporaryFolder.appendingPath("Clone"))", "-q"])
        let clone = temporaryFolder.appendingPath("Clone")
        let name = try nameOfPackage(in: clone)
        removeCloneFolder(temporaryFolder: temporaryFolder)

        return name
    }

    private func removeCloneFolder(temporaryFolder: String) {
        try? FileManager.default.removeItem(atPath: temporaryFolder.appendingPath("Clone"))
    }

    private func nameOfPackage(in folder: String) throws -> String {
        let packageFile = folder.appendingPath("Package.swift")

        for line in try String(contentsOfFile: packageFile).components(separatedBy: .newlines) {
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

//        let workspaceStateFile = generatedFolder.appendingPath(".build/workspace-state.json")
//        if !buildFolder.containsItem(named: "workspace-state.json") {
//            try buildFolder.createSymlink(to: workspaceStateFile, at: "workspace-state.json")
//        }

//        let dependenciesStateFile = generatedFolder.appendingPath(".build/dependencies-state.json")
//        if !buildFolder.containsItem(named: "dependencies-state.json") {
//            try buildFolder.createSymlink(to: dependenciesStateFile, at: "dependencies-state.json")
//        }

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
        let expectedHeader = makePackageDescriptionHeader(forSwiftToolsVersion: toolsVersion)

        guard masterDescription.hasPrefix(expectedHeader) else {
            try generateMasterPackageDescription(forSwiftToolsVersion: toolsVersion)
            return try makePackageDescription(for: script)
        }

        return masterDescription.replacingOccurrences(of: masterPackageName, with: script.name).data(using: .utf8) ?? Data()
    }

    private func updatePackages() throws {
        //           printer.reportProgress("Updating packages...")

        do {
            let executor = ShellExecutor()

            let toolsVersion = try resolveSwiftToolsVersion(executor: executor, onFolder: generatedFolder)
            try generateMasterPackageDescription(forSwiftToolsVersion: toolsVersion)
            try executeSwiftCommand("package update", onFolder: generatedFolder, arguments: [], executor: executor)
            try generatedFolder.createSubfolderIfNeeded(withName: "Packages")
        } catch {
            throw Errors.failedToUpdatePackages(folder)
        }
    }

    private func generateMasterPackageDescription(forSwiftToolsVersion toolsVersion: Version) throws {
        let header = makePackageDescriptionHeader(forSwiftToolsVersion: toolsVersion)
        let packages = makePackageList()

        var description = "\(header)\n\n" +
            "import PackageDescription\n\n" +
            "let package = Package(\n" +
            "    name: \"\(masterPackageName)\",\n" +
            "    products: [.library(name: \"DangerDependencies\", type: .dynamic, targets: [\"\(masterPackageName)\"])],\n" +
            "    dependencies: [\n"

        for (index, package) in packages.enumerated() {
            if index > 0 {
                description += ",\n"
            }

            let dependencyString = package.dependencyString(forSwiftToolsVersion: toolsVersion)
            description.append("        \(dependencyString)")
        }

        description.append("\n    ],\n")
        description.append("    targets: [.target(name: \"\(masterPackageName)\", dependencies: [")

        if !packages.isEmpty {
            description.append("\"")
            description.append(packages.map { $0.name }.joined(separator: "\", \""))
            description.append("\"")
        }

        description.append("])],\n")

        var versionString = String(toolsVersion.major)

        if toolsVersion == Version(major: 4, minor: 2, patch: 0) {
            versionString.append(".\(toolsVersion.minor)")
        }

        description.append("    swiftLanguageVersions: [.version(\"\(versionString)\")]\n)")

        FileManager.default.createFile(atPath: generatedFolder.appendingPath("Package.swift"), contents: description.data(using: .utf8), attributes: [:])
    }

    private func makePackageDescriptionHeader(forSwiftToolsVersion toolsVersion: Version) -> String {
        let swiftVersion = toolsVersion.description.trimmingCharacters(in: .whitespaces)
        let generationVersion = 1

        return "// swift-tools-version:\(swiftVersion)\n" +
            "// generation-version:\(generationVersion)"
    }

    private func resolveSwiftToolsVersion(executor: ShellExecutor, onFolder _: String) throws -> Version {
        var versionString: String? = try executeSwiftCommand("package", onFolder: folder, arguments: ["--version"], executor: executor)
        versionString = versionString?.components(separatedBy: " (swiftpm").first
        versionString = versionString?.components(separatedBy: "Swift Package Manager - Swift ").last

        let versionComponents = versionString?.components(separatedBy: ".") ?? []

        if versionComponents.count > 2 {
            versionString = "\(versionComponents[0]).\(versionComponents[1]).\(versionComponents[2])"
        }

        return Version(versionString ?? "") ?? .null
    }

    private func latestMajorVersionForPackage(at url: URL) throws -> Int {
        guard let releases = try? versions(for: url) else {
            throw Errors.failedToResolveLatestVersion(url)
        }

        guard let latestVersion = releases.sorted().last else {
            throw Errors.failedToResolveLatestVersion(url)
        }

        return latestVersion.major
    }

    private func versions(for url: URL) throws -> [Version] {
        let executor = ShellExecutor()
        let lines = try executor.spawn("git ls-remote --tags \(url.absoluteString)", arguments: []).components(separatedBy: "\n")

        return try lines.compactMap { line in
            guard let tag = line.components(separatedBy: "refs/tags/").last else {
                throw Errors.unrecognizedTagFormat(line)
            }

            return Version(tag)
        }
    }
}

public struct Package: Codable {
    public let name: String
    public let url: URL
    public var majorVersion: Int
}

extension Package {
    func dependencyString(forSwiftToolsVersion _: Version) -> String {
        return ".package(url: \"\(url.absoluteString)\", from: \"\(majorVersion).0.0\")"
    }
}

extension Package {
    struct Pinned: Decodable {
        enum CodingKeys: String, CodingKey {
            case name = "package"
            case url = "repositoryURL"
            case state
        }

        struct State: Decodable {
            let version: Version
        }

        let name: String
        let url: URL
        let state: State
    }
}

extension String {
    private enum Errors: Error {
        case creatingFolderFailed(String)
    }

    private var fileManager: FileManager {
        return .default
    }

    fileprivate var files: [String] {
        return (try? fileManager.contentsOfDirectory(atPath: self).sorted().map { self.appendingPath($0) }) ?? []
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
            throw Errors.creatingFolderFailed(folderPath)
        }
    }

    func appendingPath(_ path: String) -> String {
        if hasSuffix("/") {
            return self + path
        } else {
            return self + "/" + path
        }
    }
}

private extension Data {
    func decoded<T: Decodable>() throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: self)
    }
}

private extension Encodable {
    func encoded() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
}
