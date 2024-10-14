import DangerShellExecutor
import Foundation
import OctoKit
import RequestKit

/// Utility functions that make Dangerfiles easier to write

public struct DangerUtils {
    let fileMap: [String: String]
    let shellExecutor: ShellExecuting

    init(fileMap: [String: String], shellExecutor: ShellExecuting = ShellExecutor()) {
        self.fileMap = fileMap
        self.shellExecutor = shellExecutor
    }

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
        if let fileContent = fileMap[file] {
            return fileContent
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

        for (index, line) in lines.enumerated() {
            if line.contains(string) {
                result.append(index + 1)
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
        shellExecutor.execute(command, arguments: arguments)
    }

    /// Gives you the ability to cheaply run a command and read the
    /// output without having to mess around too much, and exposes
    /// command errors in a pretty elegant way.
    ///
    /// - Parameter command: The first part of the command
    /// - Parameter arguments: An optional array of arguements to pass in extra
    /// - Returns: the stdout from the command
    public func spawn(_ command: String, arguments: [String] = []) throws -> String {
        try shellExecutor.spawn(command, arguments: arguments)
    }

    /// Gives you the diff for a single file
    ///
    /// - Parameter file: The file path
    /// - Returns: File diff or error
    public func diff(forFile file: String, sourceBranch: String) -> Result<FileDiff, Error> {
        let parser = DiffParser()
        let diff = Result { try shellExecutor.spawn("git diff \(sourceBranch) -- \(file)", arguments: [file]) }

        return diff.flatMap {
            let diff = parser.parse($0)

            if let fileDiff = diff.first {
                return .success(fileDiff)
            } else {
                return .failure(DiffError.invalidDiff)
            }
        }
    }

    /// Converts an asynchronous function to synchronous.
    ///
    /// - Parameter body: The async function must be called inside this body and closure provided as parameter must be executed on completion
    /// - Returns: The value returned by the async function
    public func sync<T>(_ body: (@escaping (T) -> Void) -> Void) -> T {
        let group = DispatchGroup()
        var result: T!

        group.enter()

        body {
            result = $0
            group.leave()
        }

        group.wait()

        return result
    }

    public let environment = Environment()
}

extension DangerUtils {
    enum DiffError: Error, Equatable {
        case invalidDiff
    }
}

public extension DangerUtils {
    @dynamicMemberLookup
    struct Environment {
        let env: () -> [String: String]

        init(env: @escaping () -> [String: String] = { ProcessInfo.processInfo.environment }) {
            self.env = env
        }

        public subscript(dynamicMember member: String) -> Value? {
            let snakeCaseMember = "DANGER_\(member.camelCaseToSnakeCase().uppercased())"

            guard let value = env()[snakeCaseMember] else { return nil }
            if let bool = Bool(value) {
                return .boolean(bool)
            } else {
                return .string(value)
            }
        }
    }
}

public extension DangerUtils.Environment {
    enum Value: CustomStringConvertible, Equatable {
        case boolean(Bool)
        case string(String)

        public var description: String {
            switch self {
            case let .string(string):
                return string
            case let .boolean(bool):
                return bool.description
            }
        }
    }
}

public extension DangerUtils.Environment.Value? {
    func getString(default defaultString: String) -> String {
        if case let .string(value) = self { return value }
        return defaultString
    }

    func getBoolean(default defaultBoolean: Bool) -> Bool {
        if case let .boolean(value) = self { return value }
        return defaultBoolean
    }
}

private extension String {
    // Taken from https://github.com/apple/swift/blob/88b093e9d77d6201935a2c2fb13f27d961836777/stdlib/public/Darwin/Foundation/JSONEncoder.swift#L161
    // License https://github.com/apple/swift/blob/main/LICENSE.txt
    func camelCaseToSnakeCase() -> String {
        guard !isEmpty else { return self }

        var words: [Range<String.Index>] = []
        // The general idea of this algorithm is to split words on transition from lower to upper case, then on transition of >1 upper case characters to lowercase
        //
        // myProperty -> my_property
        // myURLProperty -> my_url_property
        //
        // We assume, per Swift naming conventions, that the first character of the key is lowercase.
        var wordStart = startIndex
        var searchRange = index(after: wordStart) ..< endIndex

        // Find next uppercase character
        while let upperCaseRange = rangeOfCharacter(from: CharacterSet.uppercaseLetters, options: [], range: searchRange) {
            let untilUpperCase = wordStart ..< upperCaseRange.lowerBound
            words.append(untilUpperCase)

            // Find next lowercase character
            searchRange = upperCaseRange.lowerBound ..< searchRange.upperBound
            guard let lowerCaseRange = rangeOfCharacter(from: CharacterSet.lowercaseLetters, options: [], range: searchRange) else {
                // There are no more lower case letters. Just end here.
                wordStart = searchRange.lowerBound
                break
            }

            // Is the next lowercase letter more than 1 after the uppercase? If so, we encountered a group of uppercase letters that we should treat as its own word
            let nextCharacterAfterCapital = index(after: upperCaseRange.lowerBound)
            if lowerCaseRange.lowerBound == nextCharacterAfterCapital {
                // The next character after capital is a lower case character and therefore not a word boundary.
                // Continue searching for the next upper case for the boundary.
                wordStart = upperCaseRange.lowerBound
            } else {
                // There was a range of >1 capital letters. Turn those into a word, stopping at the capital before the lower case character.
                let beforeLowerIndex = index(before: lowerCaseRange.lowerBound)
                words.append(upperCaseRange.lowerBound ..< beforeLowerIndex)

                // Next word starts at the capital before the lowercase we just found
                wordStart = beforeLowerIndex
            }
            searchRange = lowerCaseRange.upperBound ..< searchRange.upperBound
        }
        words.append(wordStart ..< searchRange.upperBound)
        let result = words.map { range in
            self[range].lowercased()
        }.joined(separator: "_")
        return result
    }
}
