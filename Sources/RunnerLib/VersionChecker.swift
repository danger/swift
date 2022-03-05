import DangerShellExecutor
import Foundation
import Logger
import Version

public struct VersionChecker {
    private let shellExecutor: ShellExecuting
    private let logger: Logger

    public init(
        shellExecutor: ShellExecuting = ShellExecutor(),
        logger: Logger
    ) {
        self.shellExecutor = shellExecutor
        self.logger = logger
    }
}

public extension VersionChecker {
    func checkForUpdate(current currentVersionString: String) {
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
}

private extension VersionChecker {
    func fetchLatestVersion() -> String? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let latest = try shellExecutor.execute("curl",
                                                   arguments: [
                                                       "-s",
                                                       "https://api.github.com/repos/danger/swift/releases/latest",
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

struct Release: Codable {
    var tagName: String
}
