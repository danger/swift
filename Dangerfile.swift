import Danger
import Foundation

let danger = Danger()

// fileImport: DangerfileExtensions/ChangelogCheck.swift
checkChangelog()

if danger.git.createdFiles.count + danger.git.modifiedFiles.count - danger.git.deletedFiles.count > 300 {
    warn("Big PR, try to keep changes smaller if you can")
}

let swiftFilesWithCopyright = danger.git.createdFiles.filter {
    $0.fileType == .swift
        && danger.utils.readFile($0).contains("//  Created by")
}

if swiftFilesWithCopyright.count > 0 {
    let files = swiftFilesWithCopyright.joined(separator: ", ")
    warn("In Danger JS we don't include copyright headers, found them in: \(files)")
}

// Test
let testFile = "Tests/DangerTests/DangerUtilsLineSearchTests.swift"
danger.utils.lines(for: "match", inFile: testFile).forEach { fail(message: "Match found", file: testFile, line: $0) }

// Support running via `danger local`
if danger.github != nil {
    // These checks only happen on a PR
    if danger.github.pullRequest.title.contains("WIP") {
        warn("PR is classed as Work in Progress")
    }

    // TODO: We're still figuring this out
    _ = danger.github.api.me { response in
        print("OK")
        switch response {
        case let .success(user):
            message(user.name ?? "")
        case .failure:
            break
        }
    }
}
