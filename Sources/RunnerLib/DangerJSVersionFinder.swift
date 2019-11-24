import DangerShellExecutor
import Logger

public final class DangerJSVersionFinder {
    public static func findDangerJSVersion(dangerJSPath: String) -> String {
        return findDangerJSVersion(dangerJSPath: dangerJSPath, executor: ShellExecutor())
    }

    static func findDangerJSVersion(dangerJSPath: String, executor: ShellExecuting) -> String {
        Logger().debug("Finding danger-js version")

        return executor.execute(dangerJSPath, arguments: ["--version"])
    }
}
