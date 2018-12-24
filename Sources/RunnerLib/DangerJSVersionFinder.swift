import Logger
import ShellOut

public final class DangerJSVersionFinder {
    public static func findDangerJSVersion(dangerJSPath: String) throws -> String {
        return try findDangerJSVersion(dangerJSPath: dangerJSPath, executor: ShellOutExecutor())
    }

    static func findDangerJSVersion(dangerJSPath: String, executor: ShellOutExecuting) throws -> String {
        Logger().debug("Finding danger-js version")

        return try executor.shellOut(command: dangerJSPath + " --version")
    }
}

public protocol ShellOutExecuting {
    func shellOut(command: String) throws -> String
}

public struct ShellOutExecutor: ShellOutExecuting {
    public func shellOut(command: String) throws -> String {
        return try ShellOut.shellOut(to: command)
    }
}
