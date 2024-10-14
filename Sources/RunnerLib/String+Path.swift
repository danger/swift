import Foundation

public extension String {
    var fullPath: String {
        if hasPrefix("/") {
            self
        } else {
            FileManager.default.currentDirectoryPath.appendingPath(self)
        }
    }

    func appendingPath(_ path: String) -> String {
        if hasSuffix("/") {
            self + path
        } else {
            self + "/" + path
        }
    }

    func removingLastPathComponent() -> String {
        let components = split(separator: "/")

        if components.count == 1 {
            return self
        } else {
            let result = components.dropLast().joined(separator: "/")

            if starts(with: "/") {
                return "/" + result
            } else {
                return result
            }
        }
    }
}
