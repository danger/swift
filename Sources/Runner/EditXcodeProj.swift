import Foundation
import Files

/// Before:
///    OTHER_SWIFT_FLAGS = (
///        "-DXcode",
///    );
///
/// After:
///    OTHER_SWIFT_FLAGS = (
///        "-I",
///        "/Users/orta/dev/projects/danger/danger-swift/.build/debug",
///        "-L",
///        "/Users/orta/dev/projects/danger/danger-swift/.build/debug",
///        "-DXcode",
///    );
///

func addLibPathToXcodeProj(xcodeprojPath: String, lib: String) throws -> Void {
    let pbxproj = try File(path: xcodeprojPath  + "project.pbxproj")
    let content = try pbxproj.readAsString()
    let before = "-DXcode\","
    let after = "-DXcode\", \"-I\", \"\(lib)\", \"-L\", \"\(lib)\""
    let newContent = content.replacingOccurrences(of: before, with: after)

    try pbxproj.write(string:newContent)
}
