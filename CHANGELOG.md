<!--

// Please add your own contribution below inside the Master section, no need to
// set a version number, that happens during a deploy. Thanks!
//
// These docs are aimed at users rather than danger developers, so please limit technical
// terminology in here.

// Note: if this is your first PR, you'll need to add your URL to the footnotes
//       see the bottom of this file

-->

## Master

- Fix not to log in to shell twice [@manicmaniac][] - [#264](https://github.com/danger/swift/pull/264)
- Use /bin/sh as command line interpreter [@manicmaniac][] - [#265](https://github.com/danger/swift/pull/265)

## 2.0.1

- Release only made for GitHub Actions - [@orta]

## 2.0.0

- Improve Platforms' models [@f-meloni][] - [#259](https://github.com/danger/swift/pull/259)
- Bitbucket Cloud support [@f-meloni][] - [#258](https://github.com/danger/swift/pull/258)

## 1.6.5

- Make BitBucketServerUser emailAddress optional [@f-meloni][] - [#257](https://github.com/danger/swift/pull/257)

## 1.6.4

- Optimise Swiftlint perfomances [@f-meloni][] - [#256](https://github.com/danger/swift/pull/256)

## 1.6.3
- Allow nil GitHub milestone descriptions [@smalljd][] - [#253](https://github.com/danger/swift/pull/253)
- Handle not existing PR commit author and contributor [@f-meloni][] - [#252](https://github.com/danger/swift/pull/252)

## 1.6.2

- Update Architecture documentation [@mollyIV][] - [#250](https://github.com/danger/swift/pull/250)
- Add support for GitHub bot users [@JosephDuffy][] - [#251](https://github.com/danger/swift/pull/251)

## 1.6.1

- Make GitLab pipeline optional [@f-meloni][] - [#248](https://github.com/danger/swift/pull/248)

## 1.6.0

- GitLab support [@f-meloni][] - [#246](https://github.com/danger/swift/pull/246) (Requires DangerJS 8.0.0+, remember to export the `DANGER_GITLAB_API_TOKEN` before use it)

## 1.5.6

- Remove free floating "mutating" keyword from DangerDSL [@sunshinejr][] - [#241](https://github.com/danger/swift/pull/241)

## 1.5.5

- Remove swift 4.0 CaseIterable implementation [@f-meloni][] - [#235](https://github.com/danger/swift/pull/238)
- Use enumerated to improve lines(for:, inFile:) function [@f-meloni][] - [#235](https://github.com/danger/swift/pull/235)
- Remove not needed force unwrap [@f-meloni][] - [#234](https://github.com/danger/swift/pull/234)
- Remove not needed coding keys [@f-meloni][] - [#233](https://github.com/danger/swift/pull/233)
- Re use the same executor on the runner [@f-meloni][] - [#230](https://github.com/danger/swift/pull/230)
- Fix Danger crashing when PR has no description [@davdroman][] - [#237](https://github.com/danger/swift/pull/237)

## 1.5.4

- Copy DangerExecutor dependency file when installing with make [@f-meloni][] - [#229](https://github.com/danger/swift/pull/229)

## 1.5.3

- Use executor to find swiftc path [@f-meloni][] - [#225](https://github.com/danger/swift/pull/225)
- Use danger shell executor instead of ShellOut [@f-meloni][] - [#224](https://github.com/danger/swift/pull/224)
- Use if let instead of try catch to decode fileMap [@f-meloni][] - [#223](https://github.com/danger/swift/pull/223)

## 1.5.2

- Fix danger-swift parameters filter [@f-meloni][] - [#216](https://github.com/danger/swift/pull/216)

## 1.5.1

- Support danger swift options and don't pass them to danger ci [@f-meloni][] - [#215](https://github.com/danger/swift/pull/215)
- Support swift 5.0 on OSX [@f-meloni][] - [#210](https://github.com/danger/swift/pull/210)

## 1.5.0

- Support custom danger-js path [@f-meloni][] - [#206](https://github.com/danger/swift/pull/206)
- Fix running SwiftLint plugin when system shell is fish [@JosephDuffy][] - [#207](https://github.com/danger/swift/pull/207)

## 1.4.0

- Make danger edit compile in the projects that are not the Danger main project [@f-meloni][] - [#204](https://github.com/danger/swift/pull/204)
- Create imported files if not present on edit command [@f-meloni][] - [#202](https://github.com/danger/swift/pull/202)
- Import correctly the files when one of the files contains an emoji [@f-meloni][] - [#198](https://github.com/danger/swift/pull/198)
- Improve file type parsing [@f-meloni][] - [#197](https://github.com/danger/swift/pull/197)
- Refactor code to fix SwiftLint warnings [@ChaosCoder][] - [#196](https://github.com/danger/swift/pull/196)
- Add ability to run swiftlint in strict mode [@FabioTacke][] - [#195](https://github.com/danger/swift/pull/195)

## 1.3.2

- Support unregistered users on BitbucketServer [@f-meloni][]  - [#193](https://github.com/danger/swift/pull/193)
- Reset markdowns on the resetDangerResults method [@f-meloni][]  - [#192](https://github.com/danger/swift/pull/192)

## 1.3.1

- Set github as var to make danger compile with swift 5 [@f-meloni][]  - [#191](https://github.com/danger/swift/pull/191)

## 1.3.0

- Accept dangerfile parameter on edit command  [@f-meloni][]  - [#189](https://github.com/danger/swift/pull/189)

## 1.2.2

- Leave SPM decide if rebuild or not the dependencies library [@f-meloni][]  - [#183](https://github.com/danger/swift/pull/183)
- Fix excluded Swiftlint paths [@absolute-heike][] - [#180](https://github.com/danger/swift/pull/180)

## 1.2.1

- Fix BitBucketServer DSL parsing by [@f-meloni][] - [#181](https://github.com/danger/swift/pull/181)

## 1.2.0

- Support a full Danger SPM usage [#174](https://github.com/danger/danger-swift/pull/174) by [@f-meloni][]
- Replace codable where was not needed by [@f-meloni][] - [#177](https://github.com/danger/swift/pull/177)
- Fix malformed Swiftlint inline paths by [@absolute-heike][] - [#176](https://github.com/danger/swift/pull/176)

## 1.1.0

- Make globalResults private by [@f-meloni][]
- Make swiftlint rule id code on the message by [@f-meloni][]
- Append Swiftlint rule id to the Swiftlint danger messages by [@f-meloni][]
- Run Swiftlint from SPM by default when available by [@f-meloni][]

## 1.0.0

It's time, Danger Swift now has enough to be useful to nearly everyone and is in use in production environments today.

As of 1.0.0, Danger Swift is fully documented at https://danger.systems/swift and sits as a peer with Ruby and
JavaScript. Most of the documentation lives here in this repo, and the reference is auto-generated.

It's been over a year of work, so I'm (orta) really glad to see this get out and be a first-class citizen for the iOS
community.

There are still some big upcoming features planned:

- A revised version of the plugin system ([#139][139])
- A synchronous GitHub API client ([#99][99])

- [@orta][] and [@f-meloni][]

This release also includes:

- Improve invalid DSL error message [@f-meloni][]
- Fail if danger-js version is below the minimum supported version by [@f-meloni][]
- Add method to get all the lines that contain a word on a file by [@f-meloni][]

## 0.8.1

- Fix danger report system by [@f-meloni][]
- More docs by [@orta][]
- Fixes for people installing via homebrew (thanks [@f-meloni][]) by [@orta][]

## 0.8.0

- Whoah! The SwiftLint plugin has been merged into Danger by [@orta][]

  This is not my work, really, it's the work of the contributors to the Danger SwiftLint plugin (which, yes, I am a
  contributor, so...) - but it's mainly the work of [@ashfurrow][] [@sunshinejr][] [@Killectro][] and [@thii][].

  This is discussed in https://github.com/ashfurrow/danger-swiftlint/issues/17 where I pitched that maybe we should just
  inline this dependency because so many people are going to use this. The Swift community is likely the only community
  using Danger Swift, so why not make this version have a bit more focus on what people are doing with it?

- Docs, lots of lots of docs by [@orta][]

  This is a blocker on 1.0ing Danger Swift. So, we're getting there now.

- Internal faffing, and splitting of some test-related code so that Plugins can have an elegant test API by [@orta][]

  This revises the way in which you can write tests in Danger plugins. Should be much easier now.

- Adds some utils functions for doing one-off commands in the terminal by [@orta][]

  `danger.utils.exec` will return the string of the STDOUT outputted by that command, use this for things you're sure
  aren't going to fail.

  `danger.utils.spawn` is a throwable version of the above which includes all the essential error information if the
  command fails.

## 0.7.3

- Add html_url support on GitHub PR [#135](https://github.com/danger/danger-swift/pull/135) by [@f-meloni][]

## 0.7.2

- Fix BitbucketServer JSON parsing [#129](https://github.com/danger/danger-swift/pull/129) by [@f-meloni][]
- Uses Danger JS's new `--passURLForDSL` for grabbing the DSL JSON - [@orta][]
- Adds `danger.utils` which has `danger.utils.readFile(file: File)` to make it easy to filter files - [@orta][]
- Adds --help option support to danger-swift [#122](https://github.com/danger/danger-swift/pull/122) by [@f-meloni][]

## 0.7.1

- Move report logic on a separate file [#111](https://github.com/danger/danger-swift/pull/111) by [@f-meloni][]

## 0.7.0

- Suggestions support [#110](https://github.com/danger/danger-swift/pull/110) by [@f-meloni][]
- Separate the Danger library from the Runner [#109](https://github.com/danger/danger-swift/pull/109) by [@f-meloni][]
- Use danger-command for calls instead of danger command [#105](https://github.com/danger/danger-swift/pull/105) by
  [@f-meloni][]

## 0.6.0

- --dangerfile argument support [#100](https://github.com/danger/danger-swift/pull/100) by [@f-meloni][]
- Add Github API client [#95](https://github.com/danger/danger-swift/pull/95) by [@f-meloni][]
- Improve danger-swift edit [#94](https://github.com/danger/danger-swift/pull/94) by [@f-meloni][]
- When working on danger, you cna now use `swift run danger-swift xx` to try commands - [@orta][]

## 0.5.1

- Ability to import files on the Dangerfile [#93](https://github.com/danger/danger-swift/pull/93) by [@f-meloni][]
- Added Shellout files on the Makefile [#91](https://github.com/danger/danger-swift/pull/91) by [@f-meloni][]
- Restored danger-swift edit functionality - [#90](https://github.com/danger/danger-swift/pull/90) by [@f-meloni][]
- Expose Danger report results - [#89](https://github.com/danger/danger-swift/pull/89) by [@f-meloni][]

* Adds three new commands:
  - `danger-swift ci` - handles running Danger
  - `danger-swift pr [https://github.com/Moya/Harvey/pull/23]` - Let's you run Danger against a PR for local dev
  - `danger-swift local - Let's you run Danger against the diff from your branch to master

- Prepares for Danger JS 5.0 - [#84](https://github.com/danger/danger-swift/pull/84) by [@orta][]

## 0.4.1

- Use CaseIterable to take advantage of compiler-generated `allCases` in enum by [yhkaplan](https://github.com/yhkaplan)
  (requires Swift 4.2)

## 0.4.0

- Change modifiedFiles, createdFiles, deletedFiles to be of type `File`, adding Name and FileType properties -
  [#81](https://github.com/danger/danger-swift/pull/81) by [yhkaplan](https://github.com/yhkaplan)
- Remove Sourcery-based code generation in favor of Swift 4.1's native Equatable conformance generation -
  [#78](https://github.com/danger/danger-swift/pull/78) by [yhkaplan](https://github.com/yhkaplan)
- [BitbucketServer] Make description, commiter and committerTimestamp optional.
  [#79](https://github.com/danger/danger-swift/pull/79) by [@acecilia](https://github.com/acecilia)
- [Github] Make repository description optional. [#73](https://github.com/danger/danger-swift/pull/73) by
  [@hiragram](https://github.com/hiragram)
- [Github] Make commit author and committer optional. [#75](https://github.com/danger/danger-swift/pull/75) by
  [@Sega-Zero](https://github.com/Sega-Zero)

## 0.4.0

- Add Support for Bitbucket Server - thomasraith

## 0.3.6

- Add Swift 4.1 support - sunshinejr

## 0.3.5

- DSL improvments - yhkaplan
- You can now `warn`, `fail`, `message` and `markdown` - sunshinejr

## 0.3.4

- Reordering how Runner args are routed to Danger - rockbruno

## 0.3.3

- Fixes for the CLI arg order from danger-js - sunshinejr

## 0.3.2

- Add milestone model to issue and pull request. - d-date
- Change date string type from `String` to `Date` using `iso8601` date decoding strategy. - d-date
- Adds the `Logger` struct together with the `--verbose` and `--silent` arguments - rockbruno
- Add support for GitHub's new review requests payload. - hirad

## 0.3.1

- Adds linker flag to link against Marathon dependencies. See https://github.com/JohnSundell/Marathon/pull/153. -
  ashfurrow

## 0.3.0

- Supports the command: `danger-swift edit` to generate an Xcodeproj which you can edit your Dangerfile in - [@orta][]
- Adds plugin infrastructure to `danger-swift` - [@orta][]

  There aren't any plugins yet, but there is infrastructure for them. By suffixing `package: [url]` to any import, you
  can directly import Swift PM package as a dependency, which is basically how plugins will work.

  So, one of these days:

  ```swift
  import SwiftLint // package: https://github.com/danger/DangerSwiftLint.git

  SwiftLint.lint(danger)
  ```

## 0.2.0

- Support the beta formatting of the JSON DSL ( it now is `{ "danger": { [DSL] }}`, instead of a root element) -
  [@orta][]

## 0.1.1

- Fix install paths for libDanger when using homebrew - [@orta][]

## 0.1.0

- First release via homebrew - eneko

## 0.0.2

- Supports a Dangerfile in both: "/Dangerfile.swift", "/danger/Dangerfile.swift" or "/Danger/Dangerfile.swift" to handle
  SPM rules on Swift files in the root - [@orta][]
- Adds a CHANGELOG, renames project to danger-swift - [@orta][]

## 0.0.1

- Initialish versions - [@orta][], SD10

[@f-meloni]: https://github.com/f-meloni
[@orta]: https://github.com/orta
[@ashfurrow]: https://github.com/ashfurrow
[@sunshinejr]: https://github.com/sunshinejr
[@killectro]: https://github.com/Killectro
[@thii]: https://github.com/thii
[@absolute-heike]: https://github.com/absolute-heike
[@ChaosCoder]: https://github.com/ChaosCoder
[@FabioTacke]: https://github.com/FabioTacke
[@JosephDuffy]: https://github.com/JosephDuffy
[@davdroman]: https://github.com/davdroman
[139]: https://github.com/danger/swift/issues/139
[99]: https://github.com/danger/swift/issues/99
[@mollyIV]: https://github.com/mollyIV
[@smalljd]: https://github.com/smalljd
[@manicmaniac]: https://github.com/manicmaniac
