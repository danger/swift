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
        if (fileMap[file]) != nil {
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

    /// Gives you the ability to cheaply run a command and read the
    /// output without having to mess around
    ///
    /// It generally assumes that the command will pass, as you only get
    /// a string reference at the end and not the process' exit code.
    ///
    /// I'm open to this changing if people want that info.
    ///
    /// - Parameter command: The first part of the command
    /// - Parameter arguments: An optional array of arguements to pass in extra
    /// - Returns: the stdout from the command
    public func exec(_ command: String, arguments: [String] = []) -> String {
        let shellExecutor = ShellExecutor()
        return shellExecutor.execute(command, arguments: arguments)
    }
}
