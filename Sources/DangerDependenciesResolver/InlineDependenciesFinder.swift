import Foundation
import Version

struct InlineDependenciesFinder {
    let fileReader: FileReading
    let config: ScriptManager.Config

    init(fileReader: FileReading = FileReader(),
         config: ScriptManager.Config)
    {
        self.fileReader = fileReader
        self.config = config
    }

    func resolveInlineDependencies(fromPath path: String,
                                   dangerSwiftVersion: Version) throws -> [InlineDependency]
    {
        let lines = try fileReader.readText(atPath: path).components(separatedBy: .newlines)

        var result: [InlineDependency] = [.dangerSwift(version: dangerSwiftVersion)]

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

                let url: URL? = {
                    #if os(macOS) && compiler(>=5.9)
                        if #available(macOS 14.0, *) {
                            return URL(string: splittedImportString[0], encodingInvalidCharacters: false)
                        }
                    #endif
                    return URL(string: splittedImportString[0])
                }()
                guard let url else {
                    throw Errors.invalidInlineDependencyURL(splittedImportString[0])
                }

                let majorVersion: Int? = splittedImportString.count > 1 ? Int(splittedImportString[1]) : nil

                result.append(InlineDependency(url: url, major: majorVersion))
            } else if let firstCharacter = line.unicodeScalars.first,
                      !CharacterSet.alphanumerics.contains(firstCharacter)
            {
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
    static func dangerSwift(version: Version) -> Self {
        .init(url: dangerSwiftRepoURL,
              major: version.major,
              minor: version.minor,
              patch: version.patch)
    }
}

extension InlineDependenciesFinder.InlineDependency {
    static let dangerSwiftRepoURL = URL(string: "https://github.com/danger/swift.git")!
}
