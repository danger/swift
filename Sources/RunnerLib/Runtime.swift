import Foundation

//  Bunch of Danger runtime util funcs

public enum Runtime {
    public static let supportedPaths = [
        "Dangerfile.swift",
        "Danger.swift",
        "danger/Dangerfile.swift",
        "Danger/Dangerfile.swift"
    ]

    /// Finds a Dangerfile from the current working directory
    public static func getDangerfile() -> String? {
        supportedPaths.first { FileManager.default.fileExists(atPath: $0) }
    }

    /// Is this a dev build: e.g. running inside a cloned danger/danger-swift
    public static let potentialLibraryFolders = [
        ".build/debug", // Working in Xcode / CLI
        ".build/x86_64-unknown-linux/debug", // Danger Swift's CI
        ".build/release", // Testing prod
        "/usr/local/lib/danger" // Homebrew installs lib stuff to here
    ]

    /// Finds a path to add at runtime to the compiler, which links
    /// to the library Danger
    public static func getLibDangerPath() -> String? {
        let fileManager = FileManager.default

        // Was danger-swift installed via marathon?
        // e.g "~/.marathon/Scripts/Temp/https:--github.com-danger-danger-swift.git/clone/.build/release"
        let marathonDangerDLDir = NSHomeDirectory() + "/.marathon/Scripts/Temp/"
        let marathonScripts = try? fileManager.contentsOfDirectory(atPath: marathonDangerDLDir)
        var depManagerDangerLibPaths: [String] = []

        if marathonScripts != nil {
            // TODO: Support running from a fork?
            let dangerSwiftPath = marathonScripts!.first { $0.contains("danger-swift") }
            if dangerSwiftPath != nil {
                let path = marathonDangerDLDir + dangerSwiftPath! + "/clone/.build/release"
                depManagerDangerLibPaths.append(path)
            }
        }

        let commandArgPath = CommandLine.arguments.first.map { arg in
            [arg.removingLastPath()]
        } ?? []

        // Check and find where we can link to libDanger from
        let libPaths = commandArgPath + potentialLibraryFolders + depManagerDangerLibPaths

        func isTheDangerLibPath(path: String) -> Bool {
            fileManager.fileExists(atPath: path + "/libDanger.dylib") || // OSX
                fileManager.fileExists(atPath: path + "/libDanger.so") // Linux
        }

        guard let path = libPaths.first(where: isTheDangerLibPath) else { return nil }

        // Always return an absolute path
        if path.starts(with: "/") {
            return path
        }

        return fileManager.currentDirectoryPath.appendingPath(path)
    }
}

public extension String {
    var fullPath: String {
        if hasPrefix("/") {
            return self
        } else {
            return FileManager.default.currentDirectoryPath.appendingPath(self)
        }
    }

    func appendingPath(_ path: String) -> String {
        if hasSuffix("/") {
            return self + path
        } else {
            return self + "/" + path
        }
    }

    func removingLastPath() -> String {
        split(separator: "/").dropLast().joined(separator: "/")
    }
}
