# danger-swift

Write your Dangerfiles in Swift 4+.

### Requirements

Latest version requires Swift 4.2

- If you are using Swift 4.1 use v0.4.1
- If you are using Swift 4.0, Use v0.3.6

Because this project recommends homebrew right now, this only works with the most recent version
of danger-swift. Ideally we'll document how to use swiftpm to version danger correctly.

### What it looks like today

You can make a Dangerfile that looks through PR metadata, it's fully typed.

```swift
import Danger

let danger = Danger()
let allSourceFiles = danger.git.modifiedFiles + danger.git.createdFiles

let changelogChanged = allSourceFiles.contains("CHANGELOG.md")
let sourceChanges = allSourceFiles.first(where: { $0.hasPrefix("Sources") })

if !changelogChanged && sourceChanges != nil {
  warn("No CHANGELOG entry added.")
}

// You can use these functions to send feedback:
message("Highlight something in the table")
warn("Something pretty bad, but not important enough to fail the build")
fail("Something that must be changed")

markdown("Free-form markdown that goes under the table, so you can do whatever.")
```

### Getting Started

Using Danger in Swift

1. Install Danger Swift: `brew install danger/tap/danger-swift`.
1. Edit the dangerfile: `danger-swift edit`.

This will make a `Dangerfile.swift` for you. then pop up a temporary 
Xcode project set up for editing a Swift Dangerfile.

### Documentation

Full documentation is available [here](Documentation/Reference/README.md).

### Commands

- `danger-swift ci` - Use this on CI
- `danger-swift pr https://github.com/Moya/Harvey/pull/23` - Use this to build your Dangerfile
- `danger-swift local` - Use this to run danger against your local changes from master
- `danger-swift edit` - Creates a temporary Xcode project for working on a Dangerfile

#### Plugins

Infrastructure exists to support plugins, which can help you avoid repeating 
the same Danger rules across separate repos. By suffixing `package: [url]` to an 
import, you can directly import Swift PM package as a dependency(through 
[Marathon][m]).

For example, a plugin could be used by the following.

```swift
// Dangerfile.swift

import DangerPlugin // package: https://github.com/username/DangerPlugin.git

DangerPlugin.doYourThing()
```

And could be implemented with the following in that repo.

```swift
// DangerPlugin.swift
import Danger

public struct DangerPlugin {
    static let danger = Danger()
    public static func doYourThing() {
        // Code goes here
    }
}
```

You can see an [example danger-swift plugin](https://github.com/ashfurrow/danger-swiftlint#danger-swiftlint).

### Setup

For a Mac:

```sh
# Install danger-swift, and a bundled danger-js locally
brew install danger/tap/danger-swift  
 # Run danger
danger-swift ci
```

For Linux:

```sh
# Install danger-swift
git clone https://github.com/danger/danger-swift.git
cd danger-swift
make install

# Install danger-js
npm install -g danger

 # Run danger
danger-swift ci
```

With Docker support ready for GitHub Actions.

#### What are the next big steps?

* [Roadmap to 1.0](https://github.com/danger/danger-swift/issues/67)
* Look into the `Class SwiftObject is implemented in both [x], [y]` runtime error, [probably this](https://bugs.swift.org/browse/SR-1060)


#### How it works

This project takes its ideas from how the Swift Package Manager handles package manifests. You can get the [long story here][spm-lr], but the TLDR is that there is a runner project which compiles and executes a runtime lib which exports its data out into JSON when the libs process is over.

So this project will export a lib `libDanger` and a CLI tool `danger-swift` which is the runner. `danger-swift` handles turning the Danger DSL JSON [message from DangerJS][dsl] and passing that into the eval'd `Dangerfile.swift`. When that process is finished it's expected that the Swift `Danger` object would post the results into a place where they can easily be passed back to DangerJS.

#### Dev

You need to be using Xcode 10.

```sh
git clone https://github.com/danger/danger-swift.git
cd danger-swift
swift build
swift package generate-xcodeproj
open Danger.xcodeproj
```

Then I tend to run `danger-swift` using `swift run`:

```sh
swift run danger-swift pr https://github.com/danger/swift/pull/95
```

If you want to emulate how DangerJS's `process` will work entirely, then use:

```sh
swift build && cat Fixtures/eidolon_609.json | ./.build/debug/danger-swift
```
#### Deploying

Run `make deploy NEW_VERSION=$VERSION` on `master` e.g. `make deploy NEW_VERSION=1.0.0`

### Long-term

I, orta, only plan on bootstrapping this project, as I won't be using this in production. I'm happy to help support others who want to own this idea and really make it shine though! So if you're interested in helping out, make a few PRs and I'll give you org access.

[m]: https://github.com/JohnSundell/Marathon
[spm-lr]: http://bhargavg.com/swift/2016/06/11/how-swiftpm-parses-manifest-file.html
[dsl]: https://github.com/danger/danger-js/pull/341
