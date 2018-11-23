import Files // package: https://github.com/JohnSundell/Files.git

import Foundation
import Danger

let danger = Danger()

// fileImport: DangerfileExtensions/ChangelogCheck.swift
checkChangelog()

if (danger.git.createdFiles.count + danger.git.modifiedFiles.count - danger.git.deletedFiles.count > 10) {
    warn("Big PR, try to keep changes smaller if you can")
}

if danger.github.pullRequest.title.contains("WIP") {
    warn("PR is classed as Work in Progress")
}

let swiftFilesWithCopyright = danger.git.createdFiles.filter {
    $0.fileType == .swift
    && danger.utils.readFile($0).includes("//  Created by")
}

if swiftFilesWithCopyright.count {
    warn("In Danger JS we don't include copyright headers, found them in: \(swiftFilesWithCopyright.joined(", "))")
}

// TODO: We're still figuring this out
_ = danger.github.api.me { response in
    print("OK")
    switch response {
    case .success(let user):
        message(user.name ?? "")
    case .failure:
        break
    }
}
