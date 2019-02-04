import Foundation

public struct SPMDanger {
    private static let dangerDepsPrefix = "DangerDeps"
    public static let buildFolder = ".build/debug"
    public let depsLibName: String

    public init?(packagePath: String = "Package.swift") {
        let packageContent = (try? String(contentsOfFile: packagePath)) ?? ""

        let regexPattern = "\\.library\\(name:[\\ ]?\"(\(SPMDanger.dangerDepsPrefix)[A-Za-z]*)"
        let regex = try? NSRegularExpression(pattern: regexPattern,
                                             options: .allowCommentsAndWhitespace)
        let firstMatch = regex?.firstMatch(in: packageContent,
                                           options: .withTransparentBounds,
                                           range: NSRange(location: 0, length: packageContent.count))

        if let depsLibNameRange = firstMatch?.range(at: 1),
            let range = Range(depsLibNameRange, in: packageContent) {
            depsLibName = String(packageContent[range])
        } else {
            return nil
        }
    }

    public func buildDependencies(executor: ShellOutExecuting = ShellOutExecutor(),
                                  fileManager _: FileManager = .default) {
        _ = try? executor.shellOut(command: "swift build --product \(depsLibName)")
    }

    public var libImport: String {
        return "-l\(depsLibName)"
    }
}
