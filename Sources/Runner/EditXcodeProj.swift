import Foundation
import Files


// Creates an xcconfig file that can be used to correctly link danger library to the xcodeproj
func createConfig(atPath configPath: String, lib: String) throws -> Void {
    let config = """
    LIBRARY_SEARCH_PATHS = \(lib)
    OTHER_SWIFT_FLAGS = -DXcode -I \(lib) -L \(lib)
    OTHER_LDFLAGS = -l danger
    """
    
    try config.write(toFile: configPath, atomically: false, encoding: .utf8)
}
