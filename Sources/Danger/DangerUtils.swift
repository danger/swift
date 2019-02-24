import Foundation

/// Utility functions that make Dangerfiles easier to write

public struct DangerUtils {
    let fileMap: [String: String]

    /// Let's you go from a file path to the contents of the file
    /// with less hassle.
    ///
    /// It specifically assumes golden path code so Dangerfiles
    /// don't have to include error handlings - an error will
    /// exit evaluation entirely as it should only happen at dev-time.
    ///
    /// - Parameter file: the file reference from git.modified/creasted/deleted etc
    /// - Returns: the file contents, or bails
    public func readFile(_ file: File) -> String {
        // Allows tests to map out their filesystem
        // via a dictionary
        if fileMap[file] != nil {
            return fileMap[file]!
        }

        // Otherwise grab it from the FS
        guard let data = FileManager.default.contents(atPath: file) else {
            print("Could not get the contents of '\(file)', failing the Dangerfile evaluation.")
            exit(1)
        }

        guard let stringy = String(data: data, encoding: .utf8) else {
            print("The '\(file)' could not be converted into a string, is it a binary?.")
            exit(1)
        }

        return stringy
    }

    /// Returns the line number of the lines that contain a specific string in a file
    ///
    /// - Parameter string: The string you want to search
    /// - Parameter file: The file path of the file where you want to search the string
    /// - Returns: the line number of the lines where the passed string is contained
    public func lines(for string: String, inFile file: File) -> [Int] {
        var result: [Int] = []

        let lines = readFile(file).components(separatedBy: .newlines)

        for i in 0 ..< lines.count {
            let line = lines[i]

            if line.contains(string) {
                result.append(i + 1)
            }
        }

        return result
    }

    /// Gives you the ability to cheaply run a command and read the
    /// output without having to mess around
    ///
    /// It generally assumes that the command will pass, as you only get
    /// a string of the STDOUT. If you think your command could/should fail
    /// then you want to use `spawn` instead.
    ///
    /// - Parameter command: The first part of the command
    /// - Parameter arguments: An optional array of arguements to pass in extra
    /// - Returns: the stdout from the command
    public func exec(_ command: String, arguments: [String] = []) -> String {
        let shellExecutor = ShellExecutor()
        return shellExecutor.execute(command, arguments: arguments)
    }

    /// Gives you the ability to cheaply run a command and read the
    /// output without having to mess around too much, and exposes
    /// command errors in a pretty elegant way.
    ///
    /// - Parameter command: The first part of the command
    /// - Parameter arguments: An optional array of arguements to pass in extra
    /// - Returns: the stdout from the command
    public func spawn(_ command: String, arguments: [String] = []) throws -> String {
        let shellExecutor = ShellExecutor()
        return try shellExecutor.spawn(command, arguments: arguments)
    }
}
