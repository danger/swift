import Files
import Foundation

// Creates an xcconfig file that can be used to correctly link danger library to the xcodeproj
func createConfig(atPath configPath: String, libPath: String, libName: String) throws {
    let config = """
    LIBRARY_SEARCH_PATHS = \(libPath)
    OTHER_SWIFT_FLAGS = -DXcode -I \(libPath) -L \(libPath)
    OTHER_LDFLAGS = -l \(libName)
    """

    try config.write(toFile: configPath, atomically: false, encoding: .utf8)
}
