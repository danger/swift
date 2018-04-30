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

* [Roadmap to 1.0](https://github.com/danger/danger-swift/issues/67)
* Look into the `Class SwiftObject is implemented in both [x], [y]` runtime error, [probably this](https://bugs.swift.org/browse/SR-1060)

### Dangerfile.swift

Setting up:

1. Install Danger Swift: `brew install danger/tap/danger-swift`.
1. Edit the dangerfile: `danger-swift edit`.

This will make a `Dangerfile.swift` for you., then pop up a temporary Xcode project set up for editing a Swift Dangerfile.

#### Plugins

Infrastructure exists to support plugins, which can help you avoid repeating the same Danger rules across separate repos. By
suffixing `package: [url]` to an import, you can directly import Swift PM package as a dependency(through [Marathon][m]), which is basically how plugins work.

For example, a plugin could be used by the following.

```swift
// Dangerfile.swift

import DangerPlugin // package: https://github.com/username/DangerPlugin.git

DangerPlugin.doYourThing()
```

And could be implemented with the following.

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
To add to or regenerate Equatable extensions for model tests, please:
1. Install Sourcery via Homebrew: ``$ brew install sourcery``
For more about Sourcery, see: https://github.com/krzysztofzablocki/Sourcery
1. Make sure any new model conforms to 'AutoEquatable', a procotol used to tell Sourcery which models to generate extensions for
``NewModel: AutoEquatable {}``
1. In the top directory of danger-swift, run: ``$ sourcery --config .sourcery.yml``
To change Sourcery settings, edit the yml file and/or the template in Sources/Templates

#### Deploying

1. Update the CHANGELOG entry
1. Edit the `Makefile` and `Sources/Danger/Danger.swift` with the version
1. Commit the changes
1. Create a git tag for the version
1. Wait a second, run `make get_sha` to grab the SHA
1. Edit the [brew formula](https://github.com/danger/homebrew-tap/edit/master/danger-swift.rb) with the new SHA/version
1. Announce

### Long-term

I, orta, only plan on bootstrapping this project, as I won't be using this in production. I'm happy to help support others who want to own this idea and really make it shine though! So if you're interested in helping out, make a few PRs and I'll give you org access.

[m]: https://github.com/JohnSundell/Marathon
[spm-lr]: http://bhargavg.com/swift/2016/06/11/how-swiftpm-parses-manifest-file.html
[dsl]: https://github.com/danger/danger-js/pull/341
