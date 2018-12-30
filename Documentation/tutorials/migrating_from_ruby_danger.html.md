g---
title: Migrating from Ruby Danger
subtitle: Moving closer to the metal
layout: guide_sw
order: 1
blurb: How to migrate an existing Danger installation
---

## Before we get started

This tutorial assumes you already have a working setup for Danger Ruby n your CI. We'll effectively be re-creating PR
[#2750 to artsy/Eigen](https://github.com/artsy/eigen/pull/2750).

## Removing the old Danger setup

Start by removing the reference to Danger in your `Gemfile`:

```diff
group :test do
-  gem 'danger' # Stop saying 'you forgot to...' in CI
```

Then run `bundle install` and your `Gemfile.lock` will be updated removing Danger from your local setup. Keep the ruby
`Dangerfile` around for now though, you will want to use it to figure out how to re-create your rules in Swift.

## Add Danger to your project

This is duplicating the [Getting Started][gs] guide, but at a highest level.

Add a `Package.swift` by running `touch Package.swift` - edit it to be something like this:

```swift
// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "[Your App]",
    dependencies: [
      .package(url: "https://github.com/danger/swift.git", from: "0.8.0")
    ],
    targets: [
        // This is just an arbitrary Swift file in our app, that has
        // no dependencies outside of Foundation, the dependencies section
        // ensures that the library for Danger gets build also.
        .target(name: "[Your App]", dependencies: ["Danger"], path: "Artsy", sources: ["Stringify.swift"]),
    ]
)
```

( Change `[Your App]`, and find a Swift file to reference via the `path:` and `sources:`. )

Run `swift build` to get everything downloaded, and ready on your computer. This will make a `Package.resolved` with
your dependencies added.

## Create a Dangerfile

Run `[swift run] danger-swift edit` to create a blank `Dangerfile.swift` and open it in Xcode.

<center>
<img src="/swift/tutorials/images/swift-edit.png">
</center>

This is your blank canvas to re-create your old rules with. Here's some rough translations of the API, based on a
[template/example](https://gist.github.com/candostdagdeviren/e49271e6a4b80f93f3193af89d10f4b1) Dangerfile for iOS apps I
found after a quick google by [@candostdagdeviren](https://github.com/candostdagdeviren):

```diff
- has_changelog_entry = !git.modified_files.include?("CHANGELOG.md")
+ let hasChangelogEntry = danger.git.modifiedFiles.contains("CHANGELOG.md")

- warn "PR is classed as Work in Progress" if bitbucket_server.pr_title.include? "[WIP]"
+ if danger.bitbucketServer.pullRequest.title.contains("WIP") {
+   warn("PR is classed as Work in Progress")
+ }

# Mainly to encourage writing up some reasoning about the PR, rather than
- if github.pr_body.length < 5
-  fail "Please provide a summary in the Pull Request description"
- end
+ if danger.github.pullRequest.body.count < 5 {
+   fail("Please provide a summary in the Pull Request description")
+ }

# If these are all empty something has gone wrong, better to raise it in a comment
- if git.modified_files.empty? && git.added_files.empty? && git.deleted_files.empty?
-   fail "This PR has no changes at all, this is likely an issue during development."
- end
+ if danger.git.modifiedFiles.isEmpty && danger.git.createdFiles.isEmpty && danger.git.deletedFiles.isEmpty {

- # Leave a warning if Podfile changes
- podfile_updated = !git.modified_files.grep(/Podfile/).empty?
- warn "The `Podfile` was updated" if podfile_updated
+ if danger.git.modifiedFiles.contains("Podfile") {
+   warn("The `Podfile` was updated")
+ }

# This lints all Swift files and leave comments in PR if
# there is any issue with linting
- swiftlint.lint_files inline_mode: true
+ SwiftLint.lint(inline: true)


- has_app_changes = !git.modified_files.grep(/ProjectName/).empty?
+ let hasAppChanges = !danger.git.modifiedFiles.filter({ $0.contains("ProjectName") }).isEmpty
- has_test_changes = !git.modified_files.grep(/ProjectNameTests/).empty?
+ let hasTestChanges = !danger.git.modifiedFiles.filter({ $0.contains("ProjectNameTests") }).isEmpty

# If changes are more than 10 lines of code, tests need to be updated too
- if has_app_changes && !has_test_changes && git.lines_of_code > 10
-  fail "Tests were not updated"
- end
+ if hasAppChanges && !hasTestChanges {
+   fail("Tests were not updated")
+ }
```

Notes:

- In rough, you can grab everything off the `danger` object in the Swift version, in Ruby you could grab they were
  global scope.
- In Danger Swift, the SwiftLint plugin is shipped with Danger - so you don't need to do any plugin management there.
- There is no equivalent to `git.lines_of_code` in Danger Swift
- Nor is there a `sticky:` in messaging in Danger Swift

## Testing it

Go back to your terminal, should be saying something like:

> `Press the return key once you're done`

So, press the return key. Now you can test your new Dangerfile by running

```sh
[swift run] danger-swift pr [a_pr_url_from_your_repo]
```

If your repo is private, you will need to either set up your access local tokens (see [Getting Started][gs]) or work
against an open source project for a second. If you need one:

```sh
[swift run] danger-swift pr https://github.com/danger/swift/pull/155
```

You can iterate here, until it does what you want.

## Deploying it

Next up, go check the CI system you use in the [Getting started][gs] guide. You're looking to change a
`bundle exec danger` to a `[swift run] danger-swift ci` basically.

Danger Swift supports all the same environment variables, and I think it supports _more_ CI services. So, that should be
good.

Make sure to add `.build` and `~/.danger-swift` to your build cache to speed things up between builds.

That's everything be it.

## Troubleshooting

#### I had a Ruby plugin which did _x_ and _y_

Yeah... Maybe I'll just point you at the ["Making a Plugin"][plugin] guide. There's also a discovery problem because
there's no central index, once there are a few plugins we can make an index on this site. If it gets bit and polished
enough, then I think it might be reasonable to move into Danger Swift too.

[gs]: /swift/guides/getting_started.html
[plugin]: /swift/usage/extending_danger.html
