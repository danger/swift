import Files // package: https://github.com/JohnSundell/Files.git

import Foundation
import Danger

let danger = Danger()

let allSourceFiles = danger.git.modifiedFiles + danger.git.createdFiles

let changelogChanged = allSourceFiles.contains("CHANGELOG.md")
let sourceChanges = allSourceFiles.first(where: { $0.hasPrefix("Sources") })
let isTrivial = danger.github.pullRequest.title.contains("#trivial")

if (danger.git.createdFiles.count + danger.git.modifiedFiles.count - danger.git.deletedFiles.count > 10) {
    warn("Big PR, try to keep changes smaller if you can")
}

if !isTrivial && !changelogChanged && sourceChanges != nil {
    warn("""
     Any changes to library code should be reflected in the Changelog.

     Please consider adding a note there and adhere to the [Changelog Guidelines](https://github.com/Moya/contributors/blob/master/Changelog%20Guidelines.md).
    """)
}

if danger.github.pullRequest.title.contains("WIP") {
    warn("PR is classed as Work in Progress")
}

warn(message: "Hello world", file: "Sources/Danger/Danger.swift", line: 11)
warn(message: "Hello world2", file: "Sources/Danger/Danger.swift", line: 13)
warn(message: "Hello world3", file: "Sources/Danger/Danger.swift", line: 15)
warn(message: "Hello world5", file: "Sources/Danger/Danger.swift", line: 17)
