import DangerShellExecutor
import Foundation

public struct SPMDanger {
    private static let dangerDepsPrefix = "DangerDeps"
    private let fileManager: FileManager
    public let depsLibName: String

    public var buildFolder: String {
        fileManager.currentDirectoryPath + "/.build/debug"
    }

    public var moduleFolder: String {
        #if compiler(<6.0)
            buildFolder
        #else
            buildFolder + "/Modules"
        #endif
    }

    public init?(
        packagePath: String = "Package.swift",
        readFile: (String) -> String? = { try? String(contentsOfFile: $0) },
        fileManager: FileManager = .default
    ) {
        self.fileManager = fileManager
        let packageContent = readFile(packagePath) ?? ""

        let regexPattern = #"\.library\([\ \n]*name:[\ ]?\"(\#(SPMDanger.dangerDepsPrefix)[A-Za-z]*)\""#
        let regex = try? NSRegularExpression(pattern: regexPattern,
                                             options: .allowCommentsAndWhitespace)
        let firstMatch = regex?.firstMatch(in: packageContent,
                                           options: [],
                                           range: NSRange(location: 0, length: packageContent.count))

        if let depsLibNameRange = firstMatch?.range(at: 1),
           let range = Range(depsLibNameRange, in: packageContent)
        {
            depsLibName = String(packageContent[range])
        } else {
            return nil
        }
    }

    public func buildDependencies(executor: ShellExecuting = ShellExecutor()) {
        executor.execute("swift build", arguments: ["--product \(depsLibName)"])
    }

    public var swiftcLibImport: String {
        "-l\(depsLibName)"
    }

    public var xcodeImportFlags: [String] {
        let libsImport = ["-l \(depsLibName)"]

        // The danger lib is not always generated, this mainly happens on the danger repo,
        // where the DangerDeps library and Danger.swiftmodule are enough
        if fileManager.fileExists(atPath: buildFolder + "/libDanger.dylib") ||
            fileManager.fileExists(atPath: buildFolder + "/libDanger.so")
        {
            return libsImport + ["-l Danger"]
        } else {
            return libsImport
        }
    }
}
