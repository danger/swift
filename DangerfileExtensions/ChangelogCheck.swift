let allSourceFiles = danger.git.modifiedFiles + danger.git.createdFiles

let changelogChanged = allSourceFiles.contains("CHANGELOG.md")
let sourceChanges = allSourceFiles.first(where: { $0.hasPrefix("Sources") })
let isTrivial = danger.github.pullRequest.title.contains("#trivial")

if !isTrivial && !changelogChanged && sourceChanges != nil {
    warn("""
     Any changes to library code should be reflected in the Changelog.

     Please consider adding a note there and adhere to the [Changelog Guidelines](https://github.com/Moya/contributors/blob/master/Changelog%20Guidelines.md).
    """)
}
