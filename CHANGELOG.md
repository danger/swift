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

## 3.18.1

- Update Node version to 18.x [@hasanabuzayed][] - [#607](https://github.com/danger/swift/pull/607)

## 3.18.0

- Fix DockerFile [@417-72KI][] - [#597](https://github.com/danger/swift/pull/597)
- Make GitLab diffRefs members public [@MontakOleg][] - [#599](https://github.com/danger/swift/pull/599)
- Prevent empty SwiftLint violation response from failure [@pouyayarandi][] - [#596](https://github.com/danger/swift/pull/599)
- Update tasks to be optional on BitBucketServer [@dromerobarria][] - [#595](https://github.com/danger/swift/pull/595)

## 3.17.1

- Use http tap url on update homebrew script [@f-meloni][]

## 3.17.0

- Edit Dangerfile as a Swift Package on `danger-swift edit` instead of xcodeproj [@417-72KI][] - [#566](https://github.com/danger/swift/pull/566)

## 3.16.0

- Update `SwiftLint` used by `danger-swift-with-swiftlint` from v0.46.1 to [0.50.3](https://github.com/realm/SwiftLint/releases/tag/0.50.3) - [#573](https://github.com/danger/swift/pull/573)
- Gitlab Error in merge request with estimate or spent time [@oscarcv][] - [#548](https://github.com/danger/swift/pull/548)
- Fix a decode error with BitBucket server [@pepix][] - [#553](https://github.com/danger/swift/pull/553)
- Resolve `// fileImport: ~` path to an absolute path on running `danger-swift edit` [@417-72KI][] - [#565](https://github.com/danger/swift/pull/565)
- Add ability to change meta information [@Nikoloutsos][] - [#567](https://github.com/danger/swift/pull/567)
- Add deactivated user status for GitLab [@antigp][] - [#572](https://github.com/danger/swift/pull/572)
- Add `squash` attribute for GitLab merge request [@aserdobintsev][] - [#576](https://github.com/danger/swift/pull/576)

## 3.15.0

- Parse GitHub commit verification [@f-meloni][] - [#547](https://github.com/danger/swift/pull/547)
- Bump Docker image base version to swift 5.7 [@mxsc][] - [#542](https://github.com/danger/swift/pull/542)
- Monterey support [@417-72KI][] - [#532](https://github.com/danger/swift/pull/532)

## 3.14.2

- Revert Swiftlint version on Dockerfile to 0.46.1 [f-meloni][] - [#540](https://github.com/danger/swift/pull/540)

## 3.14.1

- Add `reviewers` property for GitLab merge requests [@pouyayarandi][] - [#534](https://github.com/danger/swift/pull/534)
- Update [SwiftLint][] used by [danger-swift-with-swiftlint][] from v0.46.1 to [v0.49.1](https://github.com/realm/SwiftLint/releases/tag/0.49.1). [@Kiran-B][] - [#538](https://github.com/danger/swift/pull/538)
- Change `danger-swift edit` generated package to be compatible with swift 5.7 [@dahlborn][]

## 3.14.0

- Drop Swift 5.3 support [@417-72KI][] - [#524](https://github.com/danger/swift/pull/524)
- Refine runner temporary path to better support concurrent pipelines [@squarefrog][] - [#530](https://github.com/danger/swift/pull/530)

## 3.13.0

- Add platform requirements on `danger-swift edit` [@417-72KI][] - [#518](https://github.com/danger/swift/pull/518)
- Notify a new release on running danger-swift [@417-72KI][] - [#505](https://github.com/danger/swift/pull/505)
- Remove `swift-doc` from dependencies tree [@417-72KI][] - [#509](https://github.com/danger/swift/pull/509)
- Generate docker image with swift 5.5.2 [@f-meloni][] - [#501](https://github.com/danger/swift/pull/501)
- Extract dev dependencies to switch development and release easily [@417-72KI][] - [#491](https://github.com/danger/swift/pull/491)

## 3.12.3

- Add dynamic framework type only on install script [@f-meloni][] - [#485](https://github.com/danger/swift/pull/485)

## 3.12.2

- Fix Dependencies resolver on Xcode 13 [@f-meloni][] - [#482](https://github.com/danger/swift/pull/482)
- Add support for Swift 5.5 and Xcode 13 [@avdlee][] - [#480](https://github.com/danger/swift/pull/480)

## 3.12.1

- Comment Danger's internal framework on release [@f-meloni][] - [#477](https://github.com/danger/swift/pull/477)

## 3.12.0

- Fix Dockerfile node certificates [@f-meloni][] - [#471](https://github.com/danger/swift/pull/471)
- Move minumum supported version to Swift 5.3 [@lunij][] - [#414](https://github.com/danger/swift/pull/414)

## 3.11.1

- Build for Apple Silicon on Apple Silicon devices [@f-meloni][] - [#462](https://github.com/danger/swift/pull/462)

## 3.11.0

- Use swift instead of swiftc to fix compilation on Xcode 13 [@f-meloni][] - [#460](https://github.com/danger/swift/pull/460)
- Add Homebrew path for Apple Silicon based macOS installations [@majd][] - [#458](https://github.com/danger/swift/pull/458)

## 3.10.2

- Expose Danger environment from utils [@f-meloni][] - [#456](https://github.com/danger/swift/pull/456)
- Support DangerDeps definition in multiple lines [@f-meloni][] - [#447](https://github.com/danger/swift/pull/447)

## 3.10.1

- Fix homebrew [@f-meloni][] - [#435](https://github.com/danger/swift/pull/435)

## 3.10.0

- Use different structs from GitHub and Git commits [@f-meloni][] - [#433](https://github.com/danger/swift/pull/433)
- Add support to Danger enviroment [@f-meloni][] - [#431](https://github.com/danger/swift/pull/431)

## 3.9.1

- Return the correct version when `--version` is used

## 3.9.0

- Move minimum swift version to Swift 5.2 [@lunij] - [#419](https://github.com/danger/swift/pull/419)
- Fix make install for linux with swift version > 5.3 [@f-meloni][] - [#413](https://github.com/danger/swift/pull/413)

## 3.8.0

- Support package path for swiftlint [@f-meloni][] - [#413](https://github.com/danger/swift/pull/413)
- Make Danger work well with --package-path [@f-meloni][] - [#406](https://github.com/danger/swift/pull/406)
- Make `force_remove_source_branch` Optional in GitLabDSL [@417-72KI][] - [#410](https://github.com/danger/swift/pull/410)

## 3.7.2

- Decode git commits array [@f-meloni][] - [#403](https://github.com/danger/swift/pull/403)

## 3.7.1
- Fix an issue in the SwiftLint plugin where linting would fail if a `file` field was empty in the Swiftlint output [@MadsBogeskov][] - [#397](https://github.com/danger/swift/pull/397)

## 3.7.0

- Release Docker image with SwiftLint [@f-meloni][] - [#380](https://github.com/danger/swift/pull/3680)
- Handling [group milestones](https://docs.gitlab.com/ee/api/group_milestones.html#group-milestones-api). Meantime, retired `projectId` and merge it to the new enum `ParentIdentifier` which is able to handle group_id and project_id as a shared property. [@vc7][] - [#385](https://github.com/danger/swift/pull/385)
- Add .swiftlint.yml [@417-72KI][] [#383](https://github.com/danger/swift/pull/383)
- Resolve `superfluous_disable_command` [@417-72KI][] [#387](https://github.com/danger/swift/pull/387)
- Make BitBucketCloud.User accountId and nickname optional [@abel3cl][] - [#388](https://github.com/danger/swift/pull/388)

## 3.6.1

- Fix Dockerfile [@f-meloni][] - [#384](https://github.com/danger/swift/pull/384)

## 3.6.0

- Make `startDate` and `dueDate` optional for GitLab API may produce null values for these two properties [@vc7][] - [#381](https://github.com/danger/swift/pull/381)
- Fix `startDate` and `dueDate` formatting issue due to the date string from GitLab API has become `yyyy-MM-dd`, and make the date formatter is able to handle multiple format of date strings. [@vc7][] - [#381](https://github.com/danger/swift/pull/381)
- Introduce `assignees` to GitLab's MergeRequest [@vc7][] - [#381](https://github.com/danger/swift/pull/381)
- Make `draft` optional for some repos which Draft pull requests are not available in GitHub Pulls [@417-72KI][] - [#378](https://github.com/danger/swift/pull/378)
- Add Link Relations for GitHub PR [@417-72KI][] - [#368](https://github.com/danger/swift/pull/368)
- Make `SwiftLintViolation` properties public - [#377](https://github.com/danger/swift/pull/377)

## 3.5.0

- Add workaround for Xcode 12 [@f-meloni][] - [#372](https://github.com/danger/swift/pull/372)
- Deploy Danger swift Docker image on GitHub Container Registry [@f-meloni][] - [#367](https://github.com/danger/swift/pull/367)
- Create sync utils function to make async calls sync [@f-meloni][] - [#369](https://github.com/danger/swift/pull/369)

## 3.4.1

- Fix script to deploy packages on release

## 3.4.0

- Add diff for single file to danger utils [@f-meloni][] - [#362](https://github.com/danger/swift/pull/362)
- Add parser for git diff [@f-meloni][] - [#359](https://github.com/danger/swift/pull/359)

## 3.3.2

- Add dependency name when resolving for swift >= 5.2 [@f-meloni][] - [#357](https://github.com/danger/swift/pull/357)

## 3.3.1

- Search for danger-js binary before searching danger binary [@f-meloni][] - [#351](https://github.com/danger/swift/pull/351)
- Update BitBucketCloud commit user to be optional [@mahmoud-amer-m](https://github.com/mahmoud-amer-m) - [#355](https://github.com/danger/swift/pull/355)
- Update Dockerfile to use swift 5.2 [@f-meloni][] - [#330](https://github.com/danger/swift/pull/330)
- Add GitHub draft support[@captainbarbosa][] - [#341](https://github.com/danger/swift/pull/341)

## 3.3.0

- Add cwd parameter to define the current working directory [@f-meloni][] - [#333](https://github.com/danger/swift/pull/333)

## 3.2.2

- Fix danger-swift edit [@lucasmpaim][] - [#332](https://github.com/danger/swift/pull/332)

## 3.2.1

- Fix make install [@lucasmpaim][] - [#331](https://github.com/danger/swift/pull/331)

## 3.2.0

- Update OctoKit to support Xcode 11.4 [@lucasmpaim][] - [#329](https://github.com/danger/swift/pull/329)
- Use new Data API to avoid coalescing operator and optionals [@f-meloni][] - [#320](https://github.com/danger/swift/pull/320)
- Release a Dockerfile with swiftlint during releases [@f-meloni][] - [#319](https://github.com/danger/swift/pull/319)

## 3.1.0

- Parse review's submittedAt date [@f-meloni][] - [#317](https://github.com/danger/swift/pull/317)
- Use # for regex strings [@f-meloni][] - [#315](https://github.com/danger/swift/pull/315)

## 3.0.0

- Danger dependencies manager [@f-meloni][] - [#303](https://github.com/danger/swift/pull/303)
- Update swift toolchain to 5.0 [@f-meloni][] - [#307](https://github.com/danger/swift/pull/307) 
- Move to swift 5.1 [@f-meloni][] - [#275](https://github.com/danger/swift/pull/275)
- Add a new `LintStyle` enum to be able to also lint a specific set of files with SwiftLint [@avdlee][] - [#308](https://github.com/danger/swift/pull/308)

## 2.0.7

- Use enums as namespace [@f-meloni][] - [#296](https://github.com/danger/swift/pull/296) 
- Add error message when danger js is not installed [@f-meloni][] - [#295](https://github.com/danger/swift/pull/295)
- Read standard error when the shell executor fails [@f-meloni][] - [#288](https://github.com/danger/swift/pull/288)
- Add --version support [@f-meloni][] - [#287](https://github.com/danger/swift/pull/287)

## 2.0.6

- Fix GitLabDSL parsing (missing arguments) [@fortmarek][] - [#283](https://github.com/danger/swift/pull/283)
- Protect bitbucket cloud inline comment with all options being optional [@khoogheem][] - [#280](https://github.com/danger/swift/pull/280)

## 2.0.5

- Make bitbucket cloud inline comment from optional [@f-meloni][] - [#278](https://github.com/danger/swift/pull/278)

## 2.0.4

- Update Marathon to 3.3.0 [@f-meloni][] - [#272](https://github.com/danger/swift/pull/272)

## 2.0.3

- Update Marathon to a revision that supports swift 5.1 [@f-meloni][] - [#271](https://github.com/danger/swift/pull/271)
- Optimise danger actions clone [@f-meloni][] - [#270](https://github.com/danger/swift/pull/270)
- Use `command -v` instead of `which` [@f-meloni][] - [#269](https://github.com/danger/swift/pull/269)
- Remove swiftlint install commands from Dockerfile [@f-meloni][] - [#268](https://github.com/danger/swift/pull/268)

## 2.0.2

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
[@khoogheem]: https://github.com/khoogheem
[@fortmarek]: https://github.com/danger/swift/pull/283
[@avdlee]: https://github.com/AvdLee
[@lucasmpaim]: https://github.com/lucasmpaim
[@captainbarbosa]: https://github.com/captainbarbosa
[@417-72KI]: https://github.com/417-72KI
[@vc7]: https://github.com/vc7
[@lunij]: https://github.com/lunij
[@majd]: https://github.com/majd
[@pouyayarandi]: https://github.com/pouyayarandi
[@Kiran-B]: https://github.com/Kiran-B
[SwiftLint]: https://github.com/realm/SwiftLint
[danger-swift-with-swiftlint]: https://github.com/orgs/danger/packages/container/package/danger-swift-with-swiftlint
[@dahlborn]: https://github.com/dahlborn
[@MontakOleg]: https://github.com/MontakOleg
[@mxsc]: https://github.com/mxsc
[@aserdobintsev]: https://github.com/aserdobintsev
[@dromerobarria]: https://github.com/dromerobarria
