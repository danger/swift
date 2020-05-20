---
title: About the Dangerfile
subtitle: The Dangerfile
layout: guide_sw
order: 1
blurb: Step two on using Danger in your app, how to work locally and nuances around working with files.
---

## Writing your Dangerfile

All of Danger is built in Swift, so it feels Swift-y aims to have 100% in-line docs. This means a lot of your
exploration can be done inside Xcode. This document aims to give you some high level knowledge on how to work on your
`Dangerfile.swift`.

## Editing your Dangerfile

Because there's a bit of runtime trickery when evaluating your Dangerfile, and because Xcode works on projects, not
files: there is a command for editing your Dangerfile in a sandbox'd environment (including all plugins too).

```sh
[swift run] danger-swift edit
```

## Working on your Dangerfile

There are two ways to locally work on your Dangerfile. These both rely on using an external API locally, so you may hit
their API rate-limits or need to have authenticated request for private repos. In which case you can use an access token
to do authenticated requests by exposing a token to Danger.

```sh
export DANGER_GITHUB_API_TOKEN='xxxx'

# or for BitBucket by username and password
export DANGER_BITBUCKETSERVER_HOST='xxxx' DANGER_BITBUCKETSERVER_USERNAME='yyyy' DANGER_BITBUCKETSERVER_PASSWORD='zzzz'

# or for BitBucket by username and personal access token
export DANGER_BITBUCKETSERVER_HOST='xxxx' DANGER_BITBUCKETSERVER_USERNAME='yyyy' DANGER_BITBUCKETSERVER_TOKEN='zzzz'
```

Then the danger CLI will use authenticated API calls, which don't get hit by API limits.

### Using danger pr

The command `danger-swift pr` expects an argument of a PR url, e.g:

```sh
[swift run] danger-swift pr https://github.com/danger/swift/pull/95
```

This will use your local `Dangerfile.swift` against the metadata of the linked PR. Danger will then output the results
into your terminal, instead of inside the PR itself.

This _will not_ post comments in that PR.

### Using `danger` and Faking being on a CI

If you create an
[appropriately scoped temporary api token](http://danger.systems/js/guides/getting_started.html#setting-up-an-access-token)
for your GitHub account, this can be a good way to see if danger is suitable for you before integrating it into your CI
system.

You can manually trigger danger against a pull request on the command line by setting the following environmental
variables:

```bash
export DANGER_FAKE_CI="YEP"
export DANGER_TEST_REPO='username/reponame'
```

Then you can run against a local branch that is attached to a pull-request, by running the following:

```bash
git checkout branch-for-pr-1234
DANGER_TEST_PR='1234' [swift run] danger-swift ci
```

Assuming that your local file-system matches up to that branch for your code review, this will be a good approximation
of how danger will work when you integrate it into your CI system. Note: this **will** leave a comment on the PR.

### Plugins

#### Swift Package Manager (More performant)

You can use Swift PM to install both `danger-swift` and your plugins:

- Add to your `Package.swift`:

```swift
let package = Package(
...
products: [
    ...
    // Library name must start with `DangerDeps` otherwise `Danger` won't be able to import it.
    .library(name: "DangerDeps", type: .dynamic, targets: ["DangerDependencies"]), // dev
    ...
    ],
    dependencies: [
        ...
        .package(url: "https://github.com/danger/swift.git", from: "1.0.0"), // dev
        // Danger Plugins
        .package(url: "https://github.com/username/DangerPlugin.git", from: "0.1.0") // dev
        ...
    ],
    targets: [
        .target(name: "DangerDependencies", dependencies: ["Danger", "DangerPlugin"]), // dev
        ...
    ]
)
```

- Add the correct import to your `Dangerfile.swift`:

```swift
    import DangerPlugin
    
    DangerPlugin.doYourThing()
```

- Create a folder called `DangerDependencies` in `Sources` with an empty file inside like
[Fake.swift](https://github.com/danger/swift/Sources/Sources/Danger-Swift/Fake.swift)
- To run `Danger` use `swift run danger-swift command`
- **(Recommended)** If you are using Swift PM to distribute your framework, use
[Rocket](https://github.com/f-meloni/Rocket), or a similar tool, to comment out all the dev dependencies from your
`Package.swift`. This prevents these dev dependencies from being downloaded and compiled with your framework by
consumers.
- **(Recommended)** cache the `.build` folder on your repo

#### Marathon (Easy to use)

By suffixing `package: [url]` to an import, you can directly import Swift PM package as a dependency

For example, a plugin could be used by the following.

```swift
    // Dangerfile.swift
    import DangerPlugin // package: https://github.com/username/DangerPlugin.git
    
    DangerPlugin.doYourThing()
```

**(Recommended)** Cache the `~/.danger-swift` folder

## Working with files

There are a few helper functions for working with files in Danger Swift.

```swift
import Danger

let danger = Danger()

// Loop through all new files, then
let swiftFilesWithCopyright = danger.git.createdFiles.filter {
  $0.fileType == .swift && danger.utils.readFile($0).contains("//  Created by")
}

if swiftFilesWithCopyright.count > 0 {
    let files = swiftFilesWithCopyright.joined(separator: ", ")
    warn("In Danger JS we don't include copyright headers, found them in: \(files)")
}
```

You can use `$0.filetype` with any of the following enum types:

```sh
.h, .json, .m, .markdown, .mm, .pbxproj, .plist, .storyboard, .swift, .xcscheme, .yaml, .yml
```

Which makes it simple to easily create a few filtered arrays of files upfront depending on your needs.

## Utils

Because you're working in a scripting-ish environment, `danger.utils` provides a space for functions which are useful in
the context of making Dangerfiles. Currently these are functions that can let you skip some of the more verbose parts of
the Swift language in favour of Danger just crashing and failing the run.

## Finding more info

The [CHANGELOG][changelog] for Danger is kept entirely end-user focused, so if there is an aspect of the Dangerfile that
you do not know, or looks confusing and there is nothing in the documentation - [check the CHANGELOG][changelog]. This
is where we write-up why a change happened, and how it can affect Danger users.

[changelog]: http://danger.systems/swift/changelog.html
