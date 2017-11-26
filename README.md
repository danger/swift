# danger-swift

Write your Dangerfiles in Swift 4+.

### What it looks like today

You can make a Dangerfile that looks through PR metadata, it's fully typed.

```swift
import Danger

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

### CI Configuration

In your CI:

```sh
# Setup
npm install -g danger                 # Get DangerJS
brew install danger/tap/danger-swift  # Install danger-swift locally

# Script
danger process danger-swift           # Run Danger
```

### Local installation

#### Homebrew

```sh
brew install danger/tap/danger-swift
```

#### Manual install

```sh
git clone https://github.com/danger/danger-swift.git
cd danger-swift
make install
```

#### What are the next big steps?

- Add tests
- Add an [API client for GitHub](https://github.com/danger/danger-swift/issues/17)
- Improve error handling
- Write docs for end-users with examples
- Look into the `Class SwiftObject is implemented in both [x], [y]` runtime error, [probably this](https://bugs.swift.org/browse/SR-1060)

### Dangerfile.swift

Setting up: 

1. Install Danger Swift: `brew install danger/tap/danger-swift`.
1. Create a `Dangerfile.swift` in your project root: `touch Dangerfile.swift`.
1. Edit the dangerfile: `danger-swift edit`.

This will pop up a temporary Xcode project set up for editing a Swift Dangerfile. 

#### Plugins

There aren't any plugins yet, but there is infrastructure for them. By suffixing `package: [url]` to an import,
you can directly import Swift PM package as a dependency, which is basically how plugins will work.

So, one of these days:

```swift
import SwiftLint // package: https://github.com/danger/DangerSwiftLint.git

SwiftLint.lint(danger)
```

#### How it works

This project takes its ideas from how the Swift Package Manager handles package manifests. You can get the [long story here][spm-lr], but the TLDR is that there is a runner project which compiles and executes a runtime lib which exports its data out into JSON when the libs process is over.

So this project will export a lib `libDanger` and a CLI tool `danger-swift` which is the runner. `danger-swift` handles turning the Danger DSL JSON [message from DangerJS][dsl] and passing that into the eval'd `Dangerfile.swift`. When that process is finished it's expected that the Swift `Danger` object would post the results into a place where they can easily be passed back to DangerJS.

#### Dev

You need to be using Xcode 9.

```sh
git clone https://github.com/danger/danger-swift.git
cd danger-swift
swift build
swift package generate-xcodeproj
open Danger.xcodeproj
```

Then I tend to run it by eval the Dangerfile with:

```sh
swift build && swiftc --driver-mode=swift -L .build/debug -I .build/debug -lDanger Dangerfile.swift fixtures/eidolon_609.json fixtures/response_data.json
```

If you want to emulate how DangerJS's `process` will work entirely, then use:

```sh
swift build && cat fixtures/eidolon_609.json | ./.build/debug/danger-swift
```

### Long-term

I, orta, only plan on bootstrapping this project, as I won't be using this in production. I'm happy to help support others who want to own this idea and really make it shine though! So if you're interested in helping out, make a few PRs and I'll give you org access.

[m]: https://github.com/JohnSundell/Marathon/issues/59
[spm-lr]: http://bhargavg.com/swift/2016/06/11/how-swiftpm-parses-manifest-file.html
[dsl]: https://github.com/danger/danger-js/pull/341
