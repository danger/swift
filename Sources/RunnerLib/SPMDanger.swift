import DangerShellExecutor
import Foundation

public struct SPMDanger {
    private static let dangerDepsPrefix = "DangerDeps"
    private enum BuildLayout {
        case legacy
        case modern
    }

    private let fileManager: FileManager
    public let depsLibName: String

    private var modernBuildFolder: String {
        fileManager.currentDirectoryPath + "/.build/out/Products/Debug"
    }

    private var legacyBuildFolder: String {
        fileManager.currentDirectoryPath + "/.build/debug"
    }

    private var buildLayout: BuildLayout {
        if fileManager.fileExists(atPath: modernBuildFolder) {
            return .modern
        } else {
            return .legacy
        }
    }

    public var buildFolder: String {
        switch buildLayout {
        case .modern:
            return modernBuildFolder
        case .legacy:
            return legacyBuildFolder
        }
    }

    public var moduleFolder: String {
        let layout = buildLayout
        let resolvedBuildFolder = layout == .modern ? modernBuildFolder : legacyBuildFolder

        #if compiler(<6.0)
            return resolvedBuildFolder
        #else
            if layout == .modern {
                return resolvedBuildFolder
            }

            return resolvedBuildFolder + "/Modules"
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
