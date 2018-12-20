---
title: Getting started with an iOS app
subtitle: Simply Linting
layout: guide_sw
order: 1
blurb: How to use Danger on an iOS app
---

## Before we get started

This tutorial continues after "Getting Started" - it's not required that you have Danger Swift running on your CI
though, but assumes some familiarity.

# CHANGELOG Entries

This is basically the "Hello world" of Danger. You want to make a check for whether someone has made a change to your 
app's code but not checked whether a particular file has changed.

First up you're going to want to get a list of changes code which lives inside your app. You can do this by combining 
both `danger.git.modifiedFiles` and `danger.git.createdFiles`, then filtering those strings for a particular folder structure:

```swift
import Danger
let danger = Danger()

let editedFiles = danger.git.modifiedFiles + danger.git.createdFiles
let editedAppFiles = editedFiles.filter { $0.contains("/App") }
```

This is good, we can make it better by only including Swift / Objective-C implementation files:

```swift
let editedFiles = danger.git.modifiedFiles + danger.git.createdFiles
let editedAppFiles = editedFiles.filter {
    ($0.fileType == .swift  || $0.fileType == .m) &&
    $0.contains("/App") 
}
```

Now if the length of `editedAppFiles` does not equal zero, then we know there needs to be a CHANGELOG entry. This can be
detected by looking at whether  `danger.git.modifiedFiles` includes the path for your changelog.

```swift
let hasChangelogEntry = danger.git.modifiedFiles.contains("CHANGELOG.md")
```

With that, you can write the final bit of logic to wrap up the rule:

```swift
if editedAppFiles.count > 0 && !hasChangelogEntry {
  fail("Please add a CHANGELOG entry")
}
```

I like this, it's nice and simple. Unfortunately you're not strictly working with just computers (well, not really, 
people are alright I guess) and you're going to have PRs where there is an app modification that just doesn't need a 
CHANGELOG entry. Ideally, you don't want to be using Danger to impose an iron will others, so you can offer a get-out
clause. We do this regularly in production at Artsy.

One of our common tactics is too allow people to write little hashtags in the text body, or using labels on a PR to 
indicate some kind difference in this PR.

```swift
let hasSkipChangelog = danger.github.pullRequest.body.contains("#no_changelog")
// or
let hasSkipChangelog = danger.bitbucketServer.pullRequest.description?.contains("#no_changelog")
```

or

```swift
// BitBucket doesn't really have labels for PRs, from the looks of it
let skipChangelogLabel = danger.github.issue.labels.first { $0.name == "Skip Changelog" }
```

So, wrapping that all together: 

```swift
import Danger
let danger = Danger()

// Pull out the edited files and find ones that come from a sub-folder
// where our app lives
let editedFiles = danger.git.modifiedFiles + danger.git.createdFiles
let editedAppFiles = editedFiles.filter { $0.contains("/App") }

// Let people bail from the CHANGELOG check
let hasSkipChangelog = danger.github.pullRequest.body.contains("#no_changelog")
let hasSkipChangelogLabel = danger.github.issue.labels.first { $0.name == "Skip Changelog" }
let skipCheck = hasSkipChangelog || hasSkipChangelogLabel

// Request for a CHANGELOG entry with each app change
if editedAppFiles.count > 0 && !skipCheck {
  fail("Please add a CHANGELOG entry for these changes. If you would like to skip this check, add `#no_changelog` to the PR body and re-run CI.")
}
```

10/10 - cool beans

# SwiftLint for the greater good

For Danger Swift, we figured that so many people would want to use [SwiftLint][] that we built that into Danger
instead of having it as a separate plugin. That makes this section real short.

```swift
import Danger
let danger = Danger()

SwiftLint.lint()
```

That's it. Hah. Right?

That will lint the created and modified files in the pull request. It has a few options:

```swift
// Instead of making a markdown table in the main message
// sprinkle those comments inline, this can be a bit noisy
// but it definitely feels magical.
SwiftLint.lint(inline: true)

// Have different runs of SwiftLint against different sub-folders
SwiftLint.lint(directory: "Sources", configFile: ".swiftlint.yml")
SwiftLint.lint(directory: "Tests", configFile: "Tests/HarveyTests/.swiftlint.yml")

// The equivalent to running `swiftlint` in the root of the folder
SwiftLint.lint(lintAllFiles: true)

// Use a different path for SwiftLint
SwiftLint.lint(swiftlintPath: "Pods/SwiftLint/swiftlint")
```

This is mainly the work of [Ash Furrow][ash] and [Łukasz Mróz][sun] over at [danger-swiftlint][].

# Next steps

- Read the [Culture doc][culture] on how to introduce new rules without annoying teammates
- Think about code that always has to be changed in pairs in your code base, and try make a rule for that
- Explore writing a test that checks for a particular string inside a file
- Read the Dangerfile for [artsy/eigen][eigen] and [moya/harvey][moya]


[SwiftLint]: https://github.com/realm/SwiftLint/
[danger-swiftlint]: https://github.com/ashfurrow/danger-swiftlint/
[ash]: https://ashfurrow.com
[sun]: https://sunshinejr.com
[culture]: https://danger.systems/swift/usage/culture.html
[migen]: https://github.com/artsy/eigen/blob/master/Dangerfile.swift
[moya]: https://github.com/Moya/Harvey/blob/master/Dangerfile.swift

