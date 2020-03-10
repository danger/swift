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

        var result = [InlineDependency]()

        for line in lines {
            if line.hasPrefix("import ") {
                let components = line.components(separatedBy: config.dependencyPrefix)
                guard components.count > 1,
                    let lastComponent = components.last else {
                    continue
                }

                let splittedImportString = lastComponent
                  .trimmingCharacters(in: .whitespaces)
                  .components(separatedBy: " " + config.majorVersionPrefix)

                guard let url = URL(string: splittedImportString[0]) else {
                    throw Errors.invalidInlineDependencyURL(splittedImportString[0])
                }

                let majorVersion: Int?
                if splittedImportString.count > 1 {
                    let majorVersionString = splittedImportString[1]
                    majorVersion = Int(majorVersionString)
                } else {
                    majorVersion = nil
                }

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
        let url: URL
        let major: Int?
    }
}
