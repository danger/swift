import Logger
import ShellRunner

public enum DangerJSVersionFinder {
    public static func findDangerJSVersion(dangerJSPath: String) -> String {
        findDangerJSVersion(dangerJSPath: dangerJSPath, shell: ShellRunner())
    }

    static func findDangerJSVersion(dangerJSPath: String, shell: ShellRunnerProtocol) -> String {
        Logger().debug("Finding danger-js version")

        return shell.execute(dangerJSPath, arguments: ["--version"])
    }
}
