import DangerShellExecutor
import Foundation

public struct ScriptManager {
    public struct Config {
        let dependencyPrefix: String
        let dependencyFile: String

        public init(prefix: String = "package:", file: String = "Dangerplugins") {
            dependencyPrefix = prefix
            dependencyFile = file
        }
    }

    enum Errors: Error {
        case failedToCreatePackageFile(String)
        case invalidInlineDependencyURL(String)
        case failedToAddDependencyScript(String)
        case scriptNotFound(String)
    }

    private let config: Config = Config()
    private let packageManager: PackageManager
    private let folder: String
    private let cacheFolder: String
    private let temporaryFolder: String

    public init(folder: String, packageManager: PackageManager) throws {
        self.folder = folder
        cacheFolder = try folder.createSubfolderIfNeeded(withName: "Cache")
        temporaryFolder = try folder.createSubfolderIfNeeded(withName: "Temp")
        self.packageManager = packageManager
    }

    public func script(atPath path: String) throws -> Script {
        let path = path.asScriptPath()
        if FileManager.default.fileExists(atPath: path) {
            return try script(fromPath: path)
        } else {
            throw Errors.scriptNotFound(path)
        }
    }

    private func script(fromPath path: String) throws -> Script {
        let identifier = scriptIdentifier(fromPath: path)
        let folder = try createFolderIfNeededForScript(withIdentifier: identifier, filePath: path)
        let script = Script(name: path.nameExcludingExtension, folder: folder)

        if let scriptFile = try script.resolveScriptFile(fileName: config.dependencyFile) {
            try packageManager.addPackagesIfNeeded(from: scriptFile.packageURLs)
            try addDependencyScripts(fromScriptFile: scriptFile, for: script)
        }

        try resolveInlineDependencies(fromPath: path)

        do {
            try FileManager.default.createFile(atPath: folder.appendingPath("Package.swift"),
                                               contents: packageManager.makePackageDescription(for: script),
                                               attributes: [:])
        } catch {
            throw Errors.failedToCreatePackageFile(folder)
        }

        return script
    }

    private func scriptIdentifier(fromPath path: String) -> String {
        let pathExcludingExtension = path.components(separatedBy: ".swift").first
        return pathExcludingExtension?.replacingOccurrences(of: ":", with: "-")
            .replacingOccurrences(of: "/", with: "-")
            .replacingOccurrences(of: " ", with: "-") ?? "script"
    }

    private func resolveInlineDependencies(from path: String) throws {
        let lines = try String(contentsOfFile: path).components(separatedBy: .newlines)
        var packageURLs = [URL]()

        for line in lines {
            if line.hasPrefix("import ") {
                let components = line.components(separatedBy: config.dependencyPrefix)

                guard components.count > 1 else {
                    continue
                }

                let urlString = components.last!.trimmingCharacters(in: .whitespaces)

                guard let url = URL(string: urlString) else {
                    throw Errors.invalidInlineDependencyURL(urlString)
                }

                packageURLs.append(url)
            } else if let firstCharacter = line.unicodeScalars.first {
                guard !CharacterSet.alphanumerics.contains(firstCharacter) else {
                    break
                }
            }
        }

        try packageManager.addPackagesIfNeeded(from: packageURLs)
    }

    private func addDependencyScripts(fromScriptFile file: ScriptFile, for script: Script) throws {
        for url in file.scriptURLs {
            do {
                let dependencyScriptFile = url.absoluteString
                let moduleFolder = script.folder.appendingPath("Sources").appendingPath("\(script.name)")

//                let copy = try moduleFolder.createFile(named: dependencyScriptFile.name)
//                try copy.write(data: dependencyScriptFile.read())

                try FileManager.default.copyItem(atPath: dependencyScriptFile, toPath: moduleFolder.appendingPath(dependencyScriptFile.fileName))
            } catch {
                throw Errors.failedToAddDependencyScript(url.absoluteString)
            }
        }
    }

    private func resolveInlineDependencies(fromPath path: String) throws {
        let lines = try String(contentsOfFile: path).components(separatedBy: .newlines)
        var packageURLs = [URL]()

        for line in lines {
            if line.hasPrefix("import ") {
                let components = line.components(separatedBy: config.dependencyPrefix)

                guard components.count > 1 else {
                    continue
                }

                let urlString = components.last!.trimmingCharacters(in: .whitespaces)

                guard let url = URL(string: urlString) else {
                    throw Errors.invalidInlineDependencyURL(urlString)
                }

                packageURLs.append(url)
            } else if let firstCharacter = line.unicodeScalars.first {
                guard !CharacterSet.alphanumerics.contains(firstCharacter) else {
                    break
                }
            }
        }

        try packageManager.addPackagesIfNeeded(from: packageURLs)
    }

    private func createFolderIfNeededForScript(withIdentifier identifier: String, filePath: String) throws -> String {
        let scriptFolder = try cacheFolder.createSubfolderIfNeeded(withName: identifier)
        try packageManager.symlinkPackages(to: scriptFolder)

        if !FileManager.default.fileExists(atPath: scriptFolder.appendingPath("OriginalFile")) {
            try scriptFolder.createSymlink(to: filePath, at: "OriginalFile")
        }

        let sourcesFolder = try scriptFolder.createSubfolderIfNeeded(withName: "Sources")
        try FileManager.default.removeItem(atPath: sourcesFolder)

        print("moduleFolder " + filePath.nameExcludingExtension)

        let moduleFolder = try sourcesFolder.createSubfolder(withName: filePath.nameExcludingExtension)

        print("GERE")

        FileManager.default.createFile(atPath: moduleFolder.appendingPath("main.swift"),
                                       contents: try String(contentsOfFile: filePath).data(using: .utf8) ?? Data(),
                                       attributes: [:])

        return scriptFolder
    }
}

public struct Script {
    // MARK: - Properties

    public let name: String
    public let folder: String

    private var copyLoopDispatchQueue: DispatchQueue?
    private var localPath: String { return "Sources/\(name)/main.swift" }

    init(name: String, folder: String) {
        self.name = name
        self.folder = folder
    }

    func resolveScriptFile(fileName _: String) throws -> ScriptFile? {
        let scriptFile = try expandSymlink()

//        guard let parentFolder = scriptFile.parent else {
//            return nil
//        }
//
//        guard let file = try? parentFolder.file(named: fileName) else {
//            return nil
//        }
//
//        let file = "\(folder)/\(fileName)"

        return try ScriptFile(path: scriptFile)
    }

    private func expandSymlink() throws -> String {
        let executor = ShellExecutor()
        try executor.spawn("cd \(folder)", arguments: [])
        return try executor.spawn("readlink OriginalFile", arguments: [])
    }

    public func build(withArguments arguments: [String] = []) throws {
        let executor = ShellExecutor()
        try executeSwiftCommand("swift build -C \(folder)", arguments: arguments, executor: executor)
    }
}

@discardableResult
func executeSwiftCommand(_ command: String, arguments: [String] = [], executor: ShellExecutor) throws -> String {
    func resolveSwiftPath() -> String {
        #if os(Linux)
            return "swift"
        #else
            return "/usr/bin/env xcrun --sdk macosx swift"
        #endif
    }

    let swiftPath = resolveSwiftPath()
    return try executor.spawn("\(swiftPath) \(command)", arguments: arguments)
}

private extension String {
    func asScriptPath() -> String {
        let suffix = ".swift"

        guard hasSuffix(suffix) else {
            return self + suffix
        }

        return self
    }

    var nameExcludingExtension: String {
        guard let `extension` = `extension` else {
            return fileName
        }

        let endIndex = fileName.index(fileName.endIndex, offsetBy: -`extension`.count - 1)
        return String(fileName[..<endIndex])
    }

    var `extension`: String? {
        let components = fileName.components(separatedBy: ".")

        guard components.count > 1 else {
            return nil
        }

        return components.last
    }

    var fileName: String {
        return components(separatedBy: "/").last ?? "script"
    }
}
