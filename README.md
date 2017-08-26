# danger-swift

Write your Dangerfiles in Swift.

Not ready for production use. Requires [a branch of][dsl] Danger JS 2.x.

### TODO

 - Add introspection for finding the right paths for the Danger lib in the runner
 - Investigate the right path for getting it on CI ([Marathon + Homebrew][m]?)

### What it looks like today

You can make a Dangerfile that looks through modified/created/deleted files:

```swift
import Danger

let danger = Danger()
for file in danger.git.modifiedFiles {
    print(" - " + file)
}

warn("Warning: bad stuff")
fail("Failure: bad stuff happened")
markdown("## Markdown for GitHub")
```

But setting it up and running is not feasible right now, just development.

### How it works

This project takes its ideas from how the Swift Package Manager handles package manifests. You can get the [long story here][spm-lr], but the TLDR is that there is a runner which compiles and executes a runtime lib which exports its data out into JSON when the libs process is over.

So this project will export a lib ^ and a CLI tool `danger-swift` which is the runner. It will handle turning the Danger DSL JSON [message from DangerJS][dsl] and passing that into the eval'd `Dangerfile.swift`. When that process is finished it's expected that the Swift `Danger` object would post the results into a place where they can easily be passed back to DangerJS.

### Dev

If you are not using Xcode 9 beta for command-line things, run the following command:

```sh
export DEVELOPER_DIR=/Applications/Xcode-beta.app/Contents/Developer
```

Now that tab of terminal will always be using the Xcode beta. You can skip this if you change the settings in Xcode's prefs.

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

If you want to emulate how DangerJS's `process` will work entirely, then use`

```sh
swift build && cat fixtures/eidolon_609.json | ./.build/debug/danger-swift
```

### Long-term

I, orta, only want to make a small proof of concept, as I won't be using this in production. The future for Artsy mobile is JS. However, I'm happy to have someone else turn it into a real project though, and I'll hang out and be useful.

[m]: https://github.com/JohnSundell/Marathon/issues/59
[spm-lr]: http://bhargavg.com/swift/2016/06/11/how-swiftpm-parses-manifest-file.html
[dsl]: https://github.com/danger/danger-js/pull/341
