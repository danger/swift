import DangerShellExecutor
import Logger
import Version
import Foundation

public enum VersionChecker {
    public static func checkForUpdate(current currentVersionString: String) {
        guard ProcessInfo.processInfo.environment["DEBUG"] == nil else {
            return
        }
        guard let latestVersionString = fetchLatestVersion() else { return }
        guard let latestVersion = Version(latestVersionString) else {
            logger.debug("Invalid latestVersionString: (\(latestVersionString)")
            return
        }
        guard let currentVersion = Version(currentVersionString) else {
            logger.debug("Invalid currentVersionString: (\(currentVersionString)")
            return
        }
        if currentVersion < latestVersion {
            logger.logInfo("\nℹ️  A new release of danger-swift is available: \(currentVersion) -> \(latestVersion)")
        }
    }

    static func fetchLatestVersion() -> String? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let latest = try ShellExecutor().execute("curl",
                                                     arguments: [
                                                        "-s",
                                                        "https://api.github.com/repos/danger/swift/releases/latest"
                                                     ])
                .data(using: .utf8)
                .flatMap { try decoder.decode(Release.self, from: $0) }
            return latest?.tagName
        } catch {
            logger.debug(error)
            return nil
        }
    }
}

extension VersionChecker {
    static let logger = Logger()
}

struct Release: Codable {
    var tagName: String
}
