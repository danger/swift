import Files // package: https://github.com/JohnSundell/Files.git

import Foundation
import Danger

let danger = Danger()

// fileImport: DangerfileExtensions/ChangelogCheck.swift
checkChangelog()

print("Hi from the runtime")

if (danger.git.createdFiles.count + danger.git.modifiedFiles.count - danger.git.deletedFiles.count > 10) {
    warn("Big PR, try to keep changes smaller if you can")
}

if danger.github.pullRequest.title.contains("WIP") {
    warn("PR is classed as Work in Progress")
}

print("HI")
_ = danger.github.api.me { response in
    print("OK")
    switch response {
    case .success(let user):
        message(user.name ?? "")
    case .failure:
        break
    }
}
