import DangerShellExecutor
import Foundation

public struct SPMDanger {
    private static let dangerDepsPrefix = "DangerDeps"
    private let fileManager: FileManager
    public let depsLibName: String

    public var buildFolder: String {
        fileManager.currentDirectoryPath + "/.build/debug"
    }

    /// SwiftPM's module output layout depends on the toolchain *and* the selected build system,
    /// neither of which can be inferred from the compiler that built danger-swift itself (a
    /// Homebrew binary, the prebuilt universal binary, or the official Docker image — which
    /// defaults to an older Swift — are all routinely run against a different toolchain than the
    /// one building the target package):
    ///
    ///   - native build system, Swift >= 6.0:               <buildFolder>/Modules/Danger.swiftmodule
    ///   - native build system, Swift <  6.0:               <buildFolder>/Danger.swiftmodule
    ///   - swiftbuild build system (default from Xcode 27): <buildFolder>/Danger.swiftmodule
    ///
    /// `buildFolder` is the `.build/debug` symlink, which SwiftPM repoints at the current
    /// products directory on every build, so probing through it always reflects the layout that
    /// produced the artifacts we are about to link against. Probing for the exact module (not
    /// mere directory existence) avoids a false positive from an empty/partial `Modules/` left
    /// over from a prior build under a different toolchain. When the probe is ambiguous (both or
    /// neither candidate exists), keep today's compiled-in default instead of guessing, so no
    /// currently-working configuration changes behavior.
    public var moduleFolder: String {
        let flatModule = buildFolder + "/Danger.swiftmodule"
        let nestedModule = buildFolder + "/Modules/Danger.swiftmodule"

        switch (fileManager.fileExists(atPath: flatModule), fileManager.fileExists(atPath: nestedModule)) {
        case (true, false):
            return buildFolder
        case (false, true):
            return buildFolder + "/Modules"
        default:
            #if compiler(<6.0)
                return buildFolder
            #else
                return buildFolder + "/Modules"
            #endif
        }
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
