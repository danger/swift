import DangerShellExecutor
import Files
import Foundation
import MarathonCore

extension Script {
    @discardableResult
    public func setupForEdit(arguments: [String], importedFiles: [String], configPath: String) throws -> String {
        try importedFiles.forEach {
            if !FileManager.default.fileExists(atPath: $0) {
                _ = FileManager.default.createFile(atPath: $0, contents: Data(), attributes: nil)
            }
            try FileManager.default.copyItem(atPath: $0, toPath: sourcesImportPath(forImportPath: $0))
        }

        // Generate xcodeproj with the passed config
        try generateXCodeProjWithConfig(configPath: configPath)

        // Avoid Marathon to generate again the xcodeproj
        var arguments = arguments
        arguments.append("--no-xcode")

        return try setupForEdit(arguments: arguments)
    }

    public func watch(arguments: [String], importedFiles: [String]) throws {
        let dispatchQueue = DispatchQueue(label: "com.marathon.importedFilesCopyLoop")
        startImportsCopyLoop(forImports: importedFiles, dispatchQueue: dispatchQueue)

        try watch(arguments: arguments)

        try? copyImports(importedFiles)
    }

    private func startImportsCopyLoop(forImports imports: [String], dispatchQueue: DispatchQueue) {
        dispatchQueue.asyncAfter(deadline: .now() + .seconds(3)) { [weak self] in
            guard let self = self else {
                return
            }

            try? self.copyImports(imports)
            self.startImportsCopyLoop(forImports: imports, dispatchQueue: dispatchQueue)
        }
    }

    private func copyImports(_ imports: [String]) throws {
        try imports.forEach { importPath in
            let data = try File(path: sourcesImportPath(forImportPath: importPath)).read()
            try File(path: importPath).write(data: data)
        }
    }

    private func sourcesImportPath(forImportPath importPath: String) -> String {
        let fileName = importPath.split(separator: "/").last
        return folder.path + "Sources/\(name)/\(fileName ?? "")"
    }

    private func generateXCodeProjWithConfig(configPath: String) throws {
        try executeSwiftCommand("package generate-xcodeproj --xcconfig-overrides \(configPath)", in: folder)
    }

    func executeSwiftCommand(_ command: String, in folder: Folder) throws {
        func resolveSwiftPath() -> String {
            #if os(Linux)
                return "swift"
            #else
                return "/usr/bin/env xcrun --sdk macosx swift"
            #endif
        }

        let swiftPath = resolveSwiftPath()
        let executor = ShellExecutor()
        try executor.spawn("cd \(folder.path) && \(swiftPath) \(command)", arguments: [])
    }
}
