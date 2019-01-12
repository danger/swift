import Foundation

public enum SPMDanger {
    private static let depsLibName = "DangerDeps"

    public static func isSPMDanger(packagePath: String = "Package.swift") -> Bool {
        guard let packageContent = try? String(contentsOfFile: packagePath) else {
            return false
        }

        return packageContent.contains(".library(name: \"\(depsLibName)\"")
    }

    public static func buildDepsIfNeeded(executor: ShellOutExecuting = ShellOutExecutor(),
                                         fileManager: FileManager = .default) {
        if !fileManager.fileExists(atPath: ".build/debug/lib\(depsLibName).dylib"), // OSX
            !fileManager.fileExists(atPath: ".build/debug/lib\(depsLibName).so") { // Linux
            _ = try? executor.shellOut(command: "swift build --product \(depsLibName)")
        }
    }

    public static var libImport: String {
        return "-l\(depsLibName)"
    }
}
