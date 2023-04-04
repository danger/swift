import Foundation

struct InlineDependenciesFinder {
    let fileReader: FileReading
    let config: ScriptManager.Config

    init(fileReader: FileReading = FileReader(),
         config: ScriptManager.Config) {
        self.fileReader = fileReader
        self.config = config
    }

    func resolveInlineDependencies(fromPath path: String) throws -> [InlineDependency] {
        let lines = try fileReader.readText(atPath: path).components(separatedBy: .newlines)

        // TODO: inject from main.swift
        var result: [InlineDependency] = [.dangerSwift(version: "3.15.0")]

        for line in lines {
            if line.hasPrefix("import ") {
                let components = line.components(separatedBy: config.dependencyPrefix)
                guard components.count > 1,
                      let lastComponent = components.last
                else {
                    continue
                }

                let splittedImportString = lastComponent
                    .trimmingCharacters(in: .whitespaces)
                    .components(separatedBy: " " + config.majorVersionPrefix)

                guard let url = URL(string: splittedImportString[0]) else {
                    throw Errors.invalidInlineDependencyURL(splittedImportString[0])
                }

                let majorVersion: Int? = splittedImportString.count > 1 ? Int(splittedImportString[1]) : nil

                result.append(InlineDependency(url: url, major: majorVersion))
            } else if let firstCharacter = line.unicodeScalars.first,
                      !CharacterSet.alphanumerics.contains(firstCharacter) {
                break
            }
        }

        return result
    }
}

extension InlineDependenciesFinder {
    enum Errors: Error, Equatable {
        case invalidInlineDependencyURL(String)
    }
}

extension InlineDependenciesFinder {
    struct InlineDependency: Equatable {
        var url: URL
        var major: Int?
        var minor: Int?
        var patch: Int?
    }
}

extension InlineDependenciesFinder.InlineDependency {
    static func dangerSwift(version: String) -> Self {
        let components = version.split(separator: ".")
            .compactMap { Int($0) }
        precondition(components.count == 3)

        return .init(url: dangerSwiftRepoURL,
                     major: components[0],
                     minor: components[1],
                     patch: components[2])
    }
}

extension InlineDependenciesFinder.InlineDependency {
    static let dangerSwiftRepoURL = URL(string: "https://github.com/danger/swift.git")!
}
