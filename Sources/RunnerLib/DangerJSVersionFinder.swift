import Logger
import ShellRunner

public enum DangerJSVersionFinder {
    public static func findDangerJSVersion(dangerJSPath: String) -> String {
        findDangerJSVersion(dangerJSPath: dangerJSPath, shell: ShellRunner())
    }

    static func findDangerJSVersion(dangerJSPath: String, shell: ShellRunnerProtocol) -> String {
        Logger().debug("Finding danger-js version")

        do {
            return try shell.run(dangerJSPath, arguments: ["--version"])
        } catch {
            return String(describing: error)
        }
    }
}
