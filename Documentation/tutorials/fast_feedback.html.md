---
title: Fast Feedback via Danger Local
subtitle: Platformless
layout: guide_sw
order: 4
blurb: How to use Danger to get per-commit feedback
---

## Before we get started

This tutorial continues after "Getting Started" - it's not required that you have Danger Swift running on your CI
though, but assumes some familiarity.

## Locality

With Danger, the typical flow is to help you can check rules on CI and get feedback inside your PR. With Peril you can
move those rules to run on an external server making feedback instant. `danger-swift local` provides a somewhat hybrid
approach.

`danger local` provides a way to run a Dangerfile based on git-hooks. This let's you run rules while you are still in
the same context as your work as opposed to later during the code review. Personally, I find this most useful on
projects when I ship 90% of the code to it.

## How it works

Where `danger ci` uses information from the Pull Request to figure out what has changed, `danger local` naively uses the
local differences in git from master to the current commit to derive the runtime environment. This is naive because if
you don't keep your master branch in-sync, then it will be checking across potentially many branches.

Inside a Dangerfile `danger.github` and `danger.bitbucketServer` will be `nil`, so you can share a Dangerhttps://github.com/Moya/Harvey/blob/master/Dangerfile.swiftfile between
`danger local` and `danger ci` as long as you verify that these objects exist before using them.

When I thought about how I wanted to use `danger local` on repos in the Danger org, I opted to make a separate
Dangerfile for `danger local` and import this at the end of the main Dangerfile. This new Dangerfile only contains rules
which can run with just `danger.git`, e.g. CHANGELOG/README checks. I called it `Dangerfile.lite.swift`.

## Getting it set up

You need to add both Danger and [Komondor](https://github.com/orta/Komondor) to your project:

```diff
      dependencies: [
        .package(url: "https://github.com/f-meloni/Logger", from: "0.1.0"),
        .package(url: "https://github.com/JohnSundell/Marathon", from: "3.1.0"),
        .package(url: "https://github.com/JohnSundell/ShellOut", from: "2.1.0"),
        .package(url: "https://github.com/danger/danger-swift.git", from: "0.7.0")

+        .package(url: "https://github.com/orta/Komondor", from: "1.0.0"), // dev
    }
    targets: []
  }

+ #if canImport(PackageConfig)
+     import PackageConfig
+
+     let config = PackageConfig([
+         "komondor": [
+             "pre-push": "swift test",
+             "pre-commit": [
+                 "swift run danger-swift local --dangerfile Dangerfile.lite.swift",
+                 "git add .",
+             ],
+         ],
+     ])
+ #endif
```

You need to add Komondor to your install script somewhere, by adding `swift run komondor install` so that the hooks are
in place on each contributor's computer.

Then any commit creation will trigger a local run of Danger.
