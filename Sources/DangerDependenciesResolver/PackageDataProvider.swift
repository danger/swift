import DangerShellExecutor
import Foundation
import Logger
import Version

protocol PackageDataProviding {
    func nameOfPackage(at url: URL, temporaryFolder: String) throws -> String
    func latestMajorVersionForPackage(at url: URL) throws -> Int
    func resolvePinnedPackages(generatedFolder: String) throws -> [Package.Pinned]
}

struct PackageDataProvider: PackageDataProviding {
    let fileReader: FileReading
    let logger: Logger
    let executor: ShellExecuting

    init(logger: Logger,
         fileReader: FileReading = FileReader(),
         executor: ShellExecuting = ShellExecutor())
    {
        self.fileReader = fileReader
        self.logger = logger
        self.executor = executor
    }

    enum Errors: Error {
        case failedToResolveName(URL)
        case failedToReadPackageFile(String)
        case failedToResolveLatestVersion(URL)
    }

    func nameOfPackage(at url: URL, temporaryFolder: String) throws -> String {
        if case InlineDependenciesFinder.InlineDependency.dangerSwiftRepoURL = url {
            #if swift(>=5.6)
                return "Danger"
            #else
                return "danger-swift"
            #endif
        }
        do {
            guard !url.isForRemoteRepository else {
                return try nameOfRemotePackage(at: url, temporaryFolder: temporaryFolder)
            }

            let folder = url.absoluteString
            return try nameOfPackage(in: folder)
        } catch {
            throw Errors.failedToResolveName(url)
        }
    }

    func latestMajorVersionForPackage(at url: URL) throws -> Int {
        guard let releases = try? versions(for: url),
              let latestVersion = releases.sorted().last
        else {
            throw Errors.failedToResolveLatestVersion(url)
        }

        logger.logInfo("Using \(url.absoluteString) latest major:\(latestVersion.major)")

        return latestVersion.major
    }

    func resolvePinnedPackages(generatedFolder: String) throws -> [Package.Pinned] {
        // swiftlint:disable nesting
        struct ResolvedPackagesState: Decodable {
            struct Object: Decodable {
                let pins: [Package.Pinned]
            }

            enum Version {
                /// swift-tools-version <= 5.5
                case v1(object: Object)
                /// swift-tools-version >= 5.6
                case v2(pins: [Package.PinnedV2])
            }

            let version: Version

            enum CodingKeys: CodingKey {
                case object
                case pins
                case version
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let version = try container.decode(Int.self, forKey: .version)
                switch version {
                case 1:
                    let object = try container.decode(Object.self, forKey: .object)
                    self.version = .v1(object: object)
                case 2:
                    let pins = try container.decode([Package.PinnedV2].self, forKey: .pins)
                    self.version = .v2(pins: pins)
                default:
                    throw DecodingError.valueNotFound(Int.self, .init(codingPath: [CodingKeys.version], debugDescription: "Unexpected version: \(version). Danger-Swift supporting 1 or 2."))
                }
            }
        }
        // swiftlint:enable nesting

        let data = try fileReader.readData(atPath: generatedFolder.appendingPath("Package.resolved"))
        let state: ResolvedPackagesState = try data.decoded()
        switch state.version {
        case let .v1(object):
            return object.pins
        case let .v2(pins):
            return pins.v1Converted()
        }
    }

    private func nameOfRemotePackage(at url: URL, temporaryFolder: String) throws -> String {
        removeCloneFolder(temporaryFolder: temporaryFolder)

        logger.logInfo("Cloning \(url.absoluteString)...", isVerbose: true)

        let clone = temporaryFolder.appendingPath("Clone")
        try executor.spawn("git clone",
                           arguments: ["\(url.absoluteString)",
                                       "--single-branch",
                                       "--depth 1",
                                       "\(clone)", "-q"])
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

    private func versions(for url: URL) throws -> [Version] {
        let lines = try executor.spawn("git ls-remote", arguments: ["--tags", "\(url.absoluteString)"])
            .components(separatedBy: .newlines)

        return lines.compactMap { line in
            line.components(separatedBy: "refs/tags/").last.flatMap(Version.init)
        }
    }
}
