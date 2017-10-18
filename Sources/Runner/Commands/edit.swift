import Foundation
import xcproj

func editDanger() -> Void {
    // Throw the xcode proj into a rando dir
    let path = NSTemporaryDirectory()

    let proj = PBXProj(objectVersion: 1, rootObject: "OK")
    let workspace = XCWorkspace(
    let project = XcodeProj(workspace: nil, pbxproj: proj)

    // This is a dupe of run
    let supportedPaths = ["Dangerfile.swift", "danger/Dangerfile.swift", "Danger/Dangerfile.swift"]
    let resolvedDangerfile = supportedPaths.first { fileManager.fileExists(atPath: $0) }

    let myGroupFile = PBXFileReference(reference: "xxx", sourceTree: .group, path: resolvedDangerfile)
    myGroup.children.append(myGroupFile.reference)

    project.pbxproj.append(myGroupFile)
    try project.write(path: "myproject.xcodeproj")
}
