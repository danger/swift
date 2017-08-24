# danger-swift

Write your Dangerfiles in Swift.

Not ready for production use. Requires Danger JS 2.x.

### TODO

 - Read JSON from STDIN
 - A simple DSL
 - Compile & Eval the Dangerfile.swift
 - Pass results back out
 - Investigate the right path for getting it on CI ([Marathon + Homebrew][m]?)

### How it works

This project takes its ideas from how the Swift Package Manager handles it's package manifests. You can get the [long story here][spm-lr], but the TLDR is that there is a runner which compiles and executes a runtime lib which exports its data out into JSON when the libs process is over.

So this project will export a lib ^ and a CLI tool `danger-swift` which is the runner. It will handle turning the Danger DSL JSON [message from DangerJS][dsl] and passing that into the eval'd `Dangerfile.swift`. When that process is finished it's expected that the Swift `Danger` object would post the results into a place where they can easily be passed back to DangerJS.

### Dev

Make sure Xcode 9 is your CLT setup ( see prefs in Xcode )

```sh
git clone https://github.com/danger/danger-swift.git
cd danger-swift
swift build
```

Then you can eval the Dangerfile via `swiftc --driver-mode=swift -L .build/debug -I .build/debug -lDanger Dangerfile.swift`

### Long-term

I, orta, only want to make a small proof of concept, as I won't be using this in production. The future for Artsy mobile is JS. However, I'm happy to have someone else turn it into a real project though, and I'll hang out and be useful.

[m]: https://github.com/JohnSundell/Marathon/issues/59
[spm-lr]: http://bhargavg.com/swift/2016/06/11/how-swiftpm-parses-manifest-file.html
[dsl]: https://github.com/danger/danger-js/pull/341
