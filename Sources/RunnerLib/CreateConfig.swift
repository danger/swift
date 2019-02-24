import Files
import Foundation

// Creates an xcconfig file that can be used to correctly link danger library to the xcodeproj
public func createConfig(atPath configPath: String, libPath: String, libsImport: [String]) throws {
    let config = """
    LIBRARY_SEARCH_PATHS = \(libPath)
    OTHER_SWIFT_FLAGS = -DXcode -I \(libPath) -L \(libPath)
    OTHER_LDFLAGS = \(libsImport.joined(separator: " "))
    """

    try config.write(toFile: configPath, atomically: false, encoding: .utf8)
}
