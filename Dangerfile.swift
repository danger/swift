import Danger
import Foundation

if danger.git.createdFiles.count + danger.git.modifiedFiles.count - danger.git.deletedFiles.count > 300 {
    danger.warn("Big PR, try to keep changes smaller if you can")
}

SwiftLint.lint(inline: true, directory: "Sources")

let files = danger.git.modifiedFiles
danger.message(files.joined(separator: " "))
