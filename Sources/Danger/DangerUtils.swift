import Foundation

/// Utility functions that make Dangerfiles easier to write

public struct DangerUtils {
    let fileMap: [String: String]

//    init(fileMap: [String: String]) {
//        self.dsl = unowned
//    }

    /// Let's you go from a file path to the contents of the file
    /// with less hassle.

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
}
